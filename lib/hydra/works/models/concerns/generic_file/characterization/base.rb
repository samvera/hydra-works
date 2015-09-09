module Hydra::Works::GenericFile::Characterization
  module Base
    extend ActiveSupport::Concern

    autoload :FitsDatastream, 'hydra/works/models/generic_file/characterization/fits_datastream.rb'
    autoload :AlreadyThereStrategy, 'hydra/works/models/generic_file/characterization/already_there_strategy.rb'
    autoload :BaseSchema, 'hydra/works/models/generic_file/characterization/base_schema.rb'

    included do
      include Hydra::Derivatives::ExtractMetadata

      # Apply the base schema. This will add properties defined in the schema.
      apply_schema BaseSchema, AlreadyThereStrategy

      # Parser config is :term => :property.
      # Use this config to override the default behavior of value assignment which is:
      # value is assigned to the property with the same name as the characterization term.
      # use parser_config.merge! for subsequent modules.
      class_attribute :parser_config
      self.parser_config = { exif_tool_version: :exif_version,
                             file_mime_type: :mime_type }

      # Parser class is an OM terminology.
      # It maps the characterization tool's output xml to terms and values.
      class_attribute :parser_class
      self.parser_class = FitsDatastream

      # Extract the metadata from a content file and store it as properties.
      # @param [ActiveFedora::File] file to characterize
      def characterize(file = original_file)
        extracted_md = extract_metadata(file)
        terms = parse_metadata(extracted_md)
        store_metadata(terms)
      end

      protected

      def extract_metadata(file = original_file)
        return unless file.has_content?
        Hydra::FileCharacterization.characterize(file.content, file.original_name, :fits) do |cfg|
          cfg[:fits] = Hydra::Derivatives.fits_path
        end
      end

      # Use OM to parse metadata
      def parse_metadata(metadata)
        datastream = parser_class.new
        datastream.ng_xml = metadata if metadata.present?
        characterization_terms(datastream)
      end

      # Get proxy terms and values from the parser
      def characterization_terms(datastream)
        h = {}
        datastream.class.terminology.terms.each_pair do |key, target|
          # a key is a proxy if its target responds to proxied_term
          next unless target.respond_to? :proxied_term
          begin
            h[key] = datastream.send(key)
          rescue NoMethodError
            next
          end
        end
        h.delete_if { |_k, v| v.empty? }
      end

      # Assign values of the instance properties from the metadata mapping :prop => val
      def store_metadata(terms)
        terms.each_pair do |term, value|
          property = property_for(term)
          next if property.nil?
          # Array-ify the value to avoid a conditional here
          Array(value).each { |v| append_property_value(property, v) }
        end
      end

      # Check parser_config then self for matching term.
      # Return property symbol or nil
      def property_for(term)
        if parser_config.key?(term) && self.respond_to?(parser_config[term])
          parser_config[term]
        else
          term if self.respond_to?(term)
        end
      end

      def append_property_value(property, value)
        property_value = send(property)
        if property_value.is_a? Array
          property_value << value
        else
          send("#{property}=", value)
        end
      end
    end
  end
end
