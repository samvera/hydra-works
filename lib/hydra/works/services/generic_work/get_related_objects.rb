module Hydra::Works
  class GetRelatedObjectsFromGenericWork

    ##
    # Get related objects from a generic_work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work to which the child objects are related
    #
    # @return [Array<Hydra::Works::GenericWork::Base>] all related objects

    def self.call( parent_generic_work )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      Hydra::PCDM::GetRelatedObjectsFromObject.call( parent_generic_work )
    end

  end
end
