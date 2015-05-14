module Hydra::Works
  class GetRelatedObjectsFromCollection

    ##
    # Get related objects from a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection to which the child objects are related
    #
    # @return [Array<Hydra::Works::Collection>] all related objects

    def self.call( parent_collection )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      Hydra::PCDM::GetRelatedObjectsFromCollection.call( parent_collection )
    end

  end
end
