module Hydra::Works
  class RemoveRelatedObjectFromGenericWork

    ##
    # Remove an object from a generic work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_related_object )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      raise ArgumentError, 'child_related_object must be a pcdm object' unless Hydra::PCDM.object? child_related_object
      Hydra::PCDM::RemoveRelatedObjectFromObject.call( parent_generic_work, child_related_object )
    end

  end
end
