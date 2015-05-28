module Hydra::Works
  class AddGenericWorkToGenericWork

    ##
    # Add a generic_work to a generic_work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work to which to add generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being added
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_generic_work )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      raise ArgumentError, 'child_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? child_generic_work
      Hydra::PCDM::AddObjectToObject.call( parent_generic_work, child_generic_work )
    end

  end
end
