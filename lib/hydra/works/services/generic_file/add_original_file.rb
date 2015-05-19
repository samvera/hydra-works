module Hydra::Works
  class AddOriginalFile

    # Adds the original file to the work

    def self.call(object, path, replace=false)
      raise ArgumentError, "supplied object must be a generic file" unless Hydra::Works.generic_file?(object)
      raise ArgumentError, "supplied path must be a string" unless path.is_a?(String)
      raise ArgumentError, "supplied path to file does not exist" unless ::File.exists?(path)

      if replace
        current_file = object.original_file
      else
        object.files.build
        current_file = object.files.last
      end

      current_file.content = ::File.open(path)
      current_file.original_name = ::File.basename(path)
      current_file.mime_type = Hydra::Works::GetMimeTypeForFile.call(path)
      Hydra::Works::AddTypeToFile.call(current_file, ::RDF::URI("http://pcdm.org/OriginalFile"))
      current_file.save if replace
      object.save
      object
    end

  end
end
