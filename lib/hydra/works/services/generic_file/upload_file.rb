module Hydra::Works
  class UploadFileToGenericFile
    # Sets a file as the primary file (original_file) of the generic_file
    # @param [Hydra::PCDM::GenericFile::Base] generic_file the file will be added to
    # @param [IO,File,Rack::Multipart::UploadedFile, #read] object that will be the contents. If file responds to :mime_type or :original_name, those will be called to provide technical metadata.
    # @param [Array] additional_services (ie Generating Thumbnails) to call with generic_file after adding the file as its original_file
    # @param [Boolean] update_existing whether to update an existing file if there is one. When set to true, performs a create_or_update. When set to false, always creates a new file within generic_file.files.
    # @param [Boolean] versioning whether to create new version entries (only applicable if +type+ corresponds to a versionable file)

    def self.call(generic_file, file, additional_services: [], update_existing: true, versioning: true)
      Hydra::Works::AddFileToGenericFile.call(generic_file, file, :original_file, update_existing: update_existing, versioning: versioning)

      # Call any additional services
      additional_services.each do |service|
        service.call(generic_file)
      end

      generic_file.save
      generic_file
    end
  end
end
