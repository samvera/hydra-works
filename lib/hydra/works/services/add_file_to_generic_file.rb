module Hydra::Works
  class AddFileToGenericFile
    def self.call(*args)
      Deprecation.warn(AddFileToGenericFile, "AddFileToGenericFile is deprecated use AddFileToFileSet. This will be removed in 0.4.0")
      AddFileToFileSet.call(*args)
    end
  end
end
