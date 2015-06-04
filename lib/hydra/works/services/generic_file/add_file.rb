module Hydra::Works
  class AddFileToGenericFile

    # Adds the original file to the work

    def self.call(object, path, type, replace=false)
      raise ArgumentError, "supplied object must be a generic file" unless Hydra::Works.generic_file?(object)
      raise ArgumentError, "supplied path must be a string" unless path.is_a?(String)
      raise ArgumentError, "supplied path to file does not exist" unless ::File.exists?(path)

      if replace
        current_file = object.filter_files_by_type(self.type_to_uri(type)).first
      else
        object.files.build
        current_file = object.files.last
      end

      current_file.content = ::File.open(path)
      current_file.original_name = ::File.basename(path)
      current_file.mime_type = Hydra::PCDM::GetMimeTypeForFile.call(path)
      Hydra::PCDM::AddTypeToFile.call(current_file, self.type_to_uri(type))
      current_file.save if replace
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
