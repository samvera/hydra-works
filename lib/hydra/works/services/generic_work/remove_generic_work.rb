module Hydra::Works
  class RemoveGenericWorkFromGenericWork

    ##
    # Remove a generic_work from a generic_work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work from which to remove generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being removed
    # @param [Fixnum] :nth_occurrence remove nth occurrence of this generic_work in the list (default=1)
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_generic_work, nth_occurrence=1 )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      raise ArgumentError, 'child_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? child_generic_work
      Hydra::PCDM::RemoveObjectFromObject.call( parent_generic_work, child_generic_work, nth_occurrence )
    end

  end
end
