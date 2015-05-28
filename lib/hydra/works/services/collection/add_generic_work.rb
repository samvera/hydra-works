module Hydra::Works
  class AddGenericWorkToCollection

    ##
    # Add a generic_work to a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection to which to add generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being added
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_generic_work )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      raise ArgumentError, 'child_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? child_generic_work
      Hydra::PCDM::AddObjectToCollection.call( parent_collection, child_generic_work )
    end

  end
end
