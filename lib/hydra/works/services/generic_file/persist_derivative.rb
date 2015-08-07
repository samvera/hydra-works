require 'hydra/derivatives'

module Hydra::Works
  class PersistDerivative < Hydra::Derivatives::PersistOutputFileService

    ##
    # Persists a derivative to a GenericFile
    # This Service conforms to the signature of `Hydra::Derivatives::PersistOutputFileService`.  
    # The purpose of this Service is for use as an alternative to the default Hydra::Derivatives::PersistOutputFileService.  It's necessary because the default behavior in Hydra::Derivatives assumes that you're using LDP Basic Containment. Hydra::Works::GenericFiles use IndirectContainment.  This Service handles that case.
    # This service will always update existing and does not do versioning of persisted files.
    # 
    # @param [Hydra::Works::GenericFile::Base] object the file will be added to
    # @param [#read or String] file the derivative filestream optionally responds to :mime_type
    # @param [String] extract file type symbol (e.g. :thumbnail) from Hydra::Derivatives created destination_name

    def self.call(object, file, destination_name)
      type = destination_name.gsub(/^original_file_/, '').to_sym
      Hydra::Works::AddFileToGenericFile.call(object, file, type, update_existing: true, versioning: false)
    end

  end
end
