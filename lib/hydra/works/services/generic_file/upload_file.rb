module Hydra::Works
  class UploadFileToGenericFile

    # Sets a file as the primary file (original_file) of the generic_file
    # @param [Hydra::PCDM::GenericFile::Base] generic_file the file will be added to
    # @param [String] path to the file
    # @param [Array] additional_services (ie Generating Thumbnails) to call with generic_file after adding the file as its original_file
    # @param [Boolean] update_existing whether to update an existing file if there is one. When set to true, performs a create_or_update. When set to false, always creates a new file within generic_file.files.
    # @param [Boolean] versioning whether to create new version entries (only applicable if +type+ corresponds to a versionable file)

  def self.call(generic_file, path, additional_services: [], update_existing: true, versioning: true, mime_type: nil, original_name: nil)
      raise ArgumentError, "supplied object must be a generic file" unless Hydra::Works.generic_file?(generic_file)
      raise ArgumentError, "supplied path must be a string" unless path.is_a?(String)
      raise ArgumentError, "supplied path to file does not exist" unless ::File.exists?(path)

      Hydra::Works::AddFileToGenericFile.call(generic_file, path, :original_file, update_existing: update_existing, versioning: versioning, mime_type: mime_type, original_name: original_name )

      # Call any additional services
      additional_services.each do |service|
        service.call(generic_file)
      end

      generic_file.save
      generic_file
    end

  end
end
