module Hydra::Works
  class AddRelatedObjectToGenericWork

    ##
    # Add a related object to a generic work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work to which to add the related object
    # @param [Hydra::PCDM::Object] :child_related_object being added
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_related_object )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      raise ArgumentError, 'child_related_object must be a pcdm object' unless Hydra::PCDM.object? child_related_object
      Hydra::PCDM::AddRelatedObjectToObject.call( parent_generic_work, child_related_object )
    end

  end
end
