module Hydra::Works
  class UploadFileToGenericFile
    def self.call(*args)
      Deprecation.warn(UploadFileToGenericFile, "UploadFileToGenericFile is deprecated use UploadFileToFileSet. This will be removed in 0.4.0")
      UploadFileToFileSet.call(*args)
    end
  end
end
