require 'hydra/derivatives'

module Hydra::Works
  class PersistDerivative < Hydra::Derivatives::PersistOutputFileService

    ##
    # Persists a derivative to a GenericFile
    # This Service conforms to the signature of `Hydra::Derivatives::PersistOutputFileService`.  
    # The purpose of this Service is for use as an alternative to the default Hydra::Derivatives::PersistOutputFileService.  It's necessary because the default behavior in Hydra::Derivatives assumes that you're using LDP Basic Containment. Hydra::Works::GenericFiles use IndirectContainment.  This Service handles that case.
    # 
    # @param [Hydra::Works::GenericFile::Base] object the file will be added to
    # @param [#read or String] file the derivative filestream optionally responds to :mime_type
    # @param [String] extract file type symbol (e.g. :thumbnail) from Hydra::Derivatives created destination_name
    # @option opts [Boolean] update_existing when set to false, always adds a new file.  When set to true, performs a create_or_update
    # @option opts [Boolean] versioning whether to create new version entries

    def self.call(object, file, destination_name, opts={})
      type = destination_name.gsub(/^original_file_/, '').to_sym
      update_existing = opts.fetch(:update_existing, true)
      versioning = opts.fetch(:versioning, true)
      Hydra::Works::AddFileToGenericFile.call(object, file, type, update_existing: update_existing, versioning: versioning)
    end

  end
end
