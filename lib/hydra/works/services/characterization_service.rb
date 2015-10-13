require 'hydra-file_characterization'

module Hydra::Works
  class CharacterizationService
    # @param [ActiveFedora::Base] object which has properties to recieve characterization values.
    # @param [Symbol, String, File] source for characterization to be run on.  File object, path on disk, or symbol.
    #   A symbol should be the name of the method call to get object that responds to content? or is the content.
    # @param [Hash] options to be passed to characterization.  parser_mapping:, parser_class:, tools:
    def self.run(object, source = :original_file, options = {})
      new(object, source, options).characterize
    end

    attr_accessor :object, :source, :mapping, :parser_class, :tools

    def initialize(object, source, options)
      @object = object
      @source = source
      @mapping, @parser_class, @tools = extract_options(options)
    end

    # Get given source into form that can be passed to Hydra::FileCharacterization
    # Use Hydra::FileCharacterization to extract metadata (an OM Datastream)
    # Get the terms (and their values) from the extracted metadata
    # Assign the values of the terms to the properties of the object
    def characterize
      content = source_to_content
      extracted_md = extract_metadata(content)
      terms = parse_metadata(extracted_md)
      store_metadata(terms)
    end

    protected

      # Get value from opts hash, object, or use default
      def extract_options(opts)
        parser_mapping = fetch_or_respond(opts, :parser_mapping) || {}
        parser_class = fetch_or_respond(opts, :parser_class) || FitsDatastream
        ch12n_tool = opts.fetch(:ch12n_tool) { :fits }

        [parser_mapping, parser_class, ch12n_tool]
      end

      def fetch_or_respond(opts, key)
        opts.fetch(key) { object.send(key) if object.respond_to? key }
      end

      # @param [String,Symbol,File]
      # @return content if source is a symbol, File if source is string
      def source_to_content
        if source.is_a? String
          File.open(source)
        elsif source.is_a? Symbol
          s = object.send(source)
          s.respond_to?(:content) ? s.content : s
        else
          source
        end
      end

      def extract_metadata(content)
        Hydra::FileCharacterization.characterize(content, temp_file_name, tools) do |cfg|
          cfg[:fits] = Hydra::Derivatives.fits_path
        end
      end

      def temp_file_name
        m = %r{/([^/]*)$} .match(object.uri)
        "#{m[1]}-content.tmp"
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
        if mapping.key?(term) && object.respond_to?(mapping[term])
          mapping[term]
        else
          term if object.respond_to?(term)
        end
      end

      def append_property_value(property, value)
        value = object[property] + [value] if object.class.multiple?(property)
        object.send("#{property}=", value)
      end
  end
end
