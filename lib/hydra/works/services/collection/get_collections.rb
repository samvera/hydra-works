module Hydra::Works
  class GetCollectionsFromCollection

    ##
    # Get member collections from a collection in order.
    #
    # @param [Hydra::Works::Collection] :parent_collection in which the child collections are members
    #
    # @return [Array<Hydra::Works::Collection>] all member collections

    def self.call( parent_collection )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      parent_collection.collections
    end

  end
end
