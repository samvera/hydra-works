module Hydra::Works
  class RemoveRelatedObjectFromGenericFile

    ##
    # Remove an object from a generic file.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::Works::GenericFile::Base] the updated hydra works generic file

    def self.call( parent_generic_file, child_related_object )
      raise ArgumentError, 'parent_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? parent_generic_file
      raise ArgumentError, 'child_related_object must be a pcdm object' unless Hydra::PCDM.object? child_related_object
      Hydra::PCDM::RemoveRelatedObjectFromObject.call( parent_generic_file, child_related_object )
    end

  end
end
