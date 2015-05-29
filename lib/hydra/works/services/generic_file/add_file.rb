module Hydra::Works
  class AddFileToGenericFile

    # Adds the file to the object.  The file will be added as a PCDM::File to the GenericFile object.
    # @param object [GenericFile] object to which original file is being attached.
    # @param file [#read] The contents of the original file. An object which responds to read.
    # @param options [Hash] 
    # @option options [String] :original_name Name of file.
    # @option options [String] :mime_type Default will be text/plain if not given.
    # @option options [Boolean] :replace Replace first file of same type attached to the object.
    # @option options [::RDF::URI, Symbol, String] :type Type of file, e.g. :original_file, :extracted_text, or :thumbnail
    #   :type defaults to ::RDF::URI("http://pcdm.org/OriginalFile")
    def self.call(object, file, options={})
    # def self.call(object, path, type, replace=false)
      raise ArgumentError, "supplied object must be a generic file" unless Hydra::Works.generic_file?(object)
      raise ArgumentError, "supplied file must respond to read" unless file.respond_to? :read

      # get type from options or default to original file
      type = options[:type] ? self.type_to_uri(options[:type]) : ::RDF::URI("http://pcdm.org/OriginalFile")

      if options[:replace]
        current_file = object.filter_files_by_type(type).first
      else
        object.files.build
        current_file = object.files.last
      end

      current_file.content = file
      current_file.original_name = options[:original_name]  
      current_file.mime_type = options[:mime_type]

      Hydra::PCDM::AddTypeToFile.call(current_file, self.type_to_uri(type))
      current_file.save if options[:replace]
      object.save
      object
    end

    private

    # Returns appropriate URI for the requested type
    #  * Converts supported symbols to corresponding URIs
    #  * Converts URI strings to RDF::URI
    #  * Returns RDF::URI objects as-is
    def self.type_to_uri(type)
      if type.instance_of?(::RDF::URI)
        return type
      elsif type.instance_of?(Symbol)
        case type
          when :original_file
            return ::RDF::URI("http://pcdm.org/OriginalFile")
          when :thumbnail
            return ::RDF::URI("http://pcdm.org/ThumbnailImage")
          when :extracted_text
            return ::RDF::URI("http://pcdm.org/ExtractedText")
          else
            raise ArgumentError, "Invalid file type. The only valid symbols for file types are :original_file, :thumbnail, and :extracted_text.  You submitted #{type}.  To avoid this error, use one of those symbols or submit a URI instead of a symbol."
        end
      elsif type.instance_of?(String)
        return ::RDF::URI(type)
      else
        raise ArgumentError, "Invalid file type.  You must submit a URI or a symbol."
      end
    end

  end
end
