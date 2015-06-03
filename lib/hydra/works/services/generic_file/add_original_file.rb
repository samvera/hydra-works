module Hydra::Works
  class AddOriginalFile

    # Adds the original file to the work

    def self.call(object, path, replace=false)
      Hydra::Works::AddFileToGenericFile.call(object, path, ::RDF::URI("http://pcdm.org/OriginalFile"), replace)
    end

  end
end
