module Hydra::Works
  class RemoveGenericWorkFromCollection

    ##
    # Remove a generic_work from a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection from which to remove generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being removed
    # @param [Fixnum] :nth_occurrence remove nth occurrence of this generic_work in the list (default=1)
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_generic_work, nth_occurrence=1 )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      raise ArgumentError, 'child_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? child_generic_work
      Hydra::PCDM::RemoveObjectFromCollection.call( parent_collection, child_generic_work, nth_occurrence )
    end

  end
end
