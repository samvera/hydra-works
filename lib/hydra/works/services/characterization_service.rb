require 'hydra-file_characterization'

module Hydra::Works
  class CharacterizationService
    # @param [Hydra::PCDM::File] object which has properties to recieve characterization values.
    # @param [String, File] source for characterization to be run on.  File object or path on disk.
    #   If none is provided, it will assume the binary content already present on the object.
    # @param [Hash] options to be passed to characterization.  parser_mapping:, parser_class:, tools:
    def self.run(object, source = nil, options = {})
      new(object, source, options).characterize
    end

    attr_accessor :object, :source, :mapping, :parser_class, :tools
    class_attribute :terms
    self.terms = %i(
      fits_version
      format_label
      file_mime_type
      exif_tool_version
      file_size
      date_modified
      filename
      original_checksum
      date_created
      rights_basis
      copyright_basis
      copyright_note
      well_formed
      valid
      filestatus_message
      file_title
      file_author
      page_count
      file_language
      word_count
      character_count
      paragraph_count
      line_count
      table_count
      graphics_count
      byte_order
      compression
      width
      video_width
      video_track_width
      height
      video_height
      video_track_height
      color_space
      profile_name
      profile_version
      orientation
      color_map
      image_producer
      capture_device
      scanning_software
      exif_version
      gps_timestamp
      latitude
      longitude
      character_set
      markup_basis
      markup_language
      audio_duration
      video_duration
      bit_depth
      audio_sample_rate
      video_sample_rate
      video_audio_sample_rate
      channels
      data_format
      offset
      frame_rate
      audio_bit_rate
      video_bit_rate
      track_frame_rate
      aspect_ratio
    )

    def initialize(object, source, options)
      @object       = object
      @source       = source
      @mapping      = options.fetch(:parser_mapping, Hydra::Works::Characterization.mapper)
      @parser_class = options.fetch(:parser_class, Hydra::Works::Characterization::FitsDocument)
      @tools        = options.fetch(:ch12n_tool, :fits)
    end

    # Get given source into form that can be passed to Hydra::FileCharacterization
    # Use Hydra::FileCharacterization to extract metadata (an OM XML document)
    # Get the terms (and their values) from the extracted metadata
    # Assign the values of the terms to the properties of the object
    def characterize
      content = source_to_content
      extracted_md = extract_metadata(content)
      terms = parse_metadata(extracted_md)
      store_metadata(terms)
    end

    protected

      # @return content of object if source is nil; otherwise, return a File or the source
      def source_to_content
        return object.content if source.nil?
        # do not read the file into memory It could be huge...
        return File.open(source) if source.is_a? String
        source.rewind
        source.read
      end

      def extract_metadata(content)
        Hydra::FileCharacterization.characterize(content, file_name, tools) do |cfg|
          cfg[:fits] = Hydra::Derivatives.fits_path
        end
      end

      # Determine the filename to send to Hydra::FileCharacterization. If no source is present,
      # use the name of the file from the object; otherwise, use the supplied source.
      def file_name
        if source
          source.is_a?(File) ? File.basename(source.path) : File.basename(source)
        else
          object.original_name.nil? ? "original_file" : object.original_name
        end
      end

      # Use Happymapper to parse metadata
      def parse_metadata(metadata)
        doc = parser_class.new
        doc.parse(metadata) if metadata.present?
        characterization_terms(doc)
      end

      # Get proxy terms and values from the parser
      def characterization_terms(doc)
        h = {}
        terms.each do |key|
          begin
            h[key] = doc.public_send(key)
          rescue NoMethodError
            next
          end
        end
        h.delete_if { |_k, v| v.blank? }
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
        if mapping.key?(term) && object.respond_to?(mapping[term])
          mapping[term]
        elsif object.respond_to?(term)
          term
        end
      end

      def append_property_value(property, value)
        # We don't want multiple mime_types; this overwrites each time to accept last value
        value = object.public_send(property) + [value] unless property == :mime_type
        # We don't want multiple heights / widths, pick the max
        value = value.map(&:to_i).max.to_s if property == :height || property == :width
        object.send("#{property}=", value)
      end
  end
end
