include RDF

module Hydra::Works::GenericFile
  module Characterization
    extend ActiveSupport::Concern

    autoload :SaxDoc, 'hydra/works/models/generic_file/characterization/sax_doc'

    DEFAULT_FITS_TO_RDF = { filename: "filename",
                            mime_type: ["identity", "toolname=FITS", "mimetype"],
                            file_size: "size",
                            well_formed: "well-formed",
                            valid: "valid",
                            last_modified: ["lastmodified", "toolname=Exiftool"],
                            date_created: ["created", "toolname=Exiftool"],
                            fits_version: %w(fits version),
                            exif_version: ["tool", "toolname=Exiftool", "toolversion"],
                            original_checksum: "md5checksum" }

    # Setter for instance parse_config
    def parse_config=(cfg)
      @parse_config = cfg
    end

    # Instance method for obtaining the parse_config where instance trumps class if present.
    def parse_config
      @parse_config || self.class.parse_config
    end

    included do
      include Hydra::Derivatives::ExtractMetadata

      # Base characterization properties

      property :filename, predicate: RDF::Vocab::EBUCore.filename, multiple: false
      property :file_size, predicate: RDF::Vocab::EBUCore.fileSize, multiple: false
      property :well_formed, predicate: RDF::URI.new("http://projecthydra.org/ns/fits/wellFormed"), multiple: false
      property :valid, predicate: RDF::URI.new("http://projecthydra.org/ns/fits/valid"), multiple: false
      property :date_created, predicate: RDF::Vocab::EBUCore.dateCreated, multiple: false
      property :last_modified, predicate: RDF::Vocab::EBUCore.dateModified, multiple: false
      property :fits_version, predicate: RDF::Vocab::PREMIS.hasCreatingApplicationVersion
      property :exif_version, predicate: RDF::Vocab::EXIF.exifVersion
      property :original_checksum, predicate: RDF::Vocab::PREMIS.hasMessageDigest, multiple: false
      # ebucore:hasMimeType multiple: false
      # property :mime_type, delegate_to: 'original_file'
      property :mime_type, predicate: RDF::Vocab::EBUCore.hasMimeType, multiple: false

      # Use rails class_attribute which is inherited by subclasses, and independently mutable by them.
      class_attribute :parse_config
      self.parse_config = ::Hydra::Works::GenericFile::Characterization::DEFAULT_FITS_TO_RDF.dup

      # Extract the metadata from a content file and store it as properties.
      # The target properties must already exist.
      # @param [ActiveFedora::File] file to characterize
      def characterize(file = original_file)
        # Run fits and get xml string
        extracted_md = extract_metadata(file)
        # Parse xml string to get properties and values
        prop_values = parse_metadata(extracted_md)
        # Store metadata as properties of the file.
        # store_metadata(file.metadata_node, extract_metadata)
        store_metadata(prop_values)
      end

      protected

      def extract_metadata(file = original_file)
        return unless file.has_content?
        Hydra::FileCharacterization.characterize(file.content, file.original_name, :fits) do |cfg|
          cfg[:fits] = Hydra::Derivatives.fits_path
        end
      end

      def parse_metadata(md)
        parser = Nokogiri::XML::SAX::Parser.new(Hydra::Works::GenericFile::Characterization::SaxDoc.new(parse_config))
        parser.parse(md)
        parser.document.property_values
      end

      # Assign values of the instance properties from the metadata mapping :prop => val
      # Multi-valued properties are arrays. Single valued property cannot be appended to.
      def store_metadata(metadata)
        metadata.each_pair do |prop, val|
          next unless self.respond_to? prop
          property = send(prop)
          if property.is_a? Array
            property << val
          else
            val.is_a?(Array) ? send("#{prop}=", val.first) : send("#{prop}=", val)
          end
        end
      end
    end
  end
end
