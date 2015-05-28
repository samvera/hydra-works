module Hydra::Works
  class AddRelatedObjectToGenericFile

    ##
    # Add a related object to a generic file.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file to which to add the related object
    # @param [Hydra::PCDM::Object] :child_related_object being added
    #
    # @return [Hydra::Works::GenericFile::Base] the updated hydra works generic file

    def self.call( parent_generic_file, child_related_object )
      raise ArgumentError, 'parent_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? parent_generic_file
      raise ArgumentError, 'child_related_object must be a pcdm object' unless Hydra::PCDM.object? child_related_object
      Hydra::PCDM::AddRelatedObjectToObject.call( parent_generic_file, child_related_object )
    end

  end
end
