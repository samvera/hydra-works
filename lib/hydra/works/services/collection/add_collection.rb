module Hydra::Works
  class AddCollectionToCollection

    ##
    # Add a collection to a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection to which to add collection
    # @param [Hydra::Works::Collection] :child_collection being added
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_collection )
      warn "[DEPRECATION] `Hydra::Works::AddCollectionToCollection` is deprecated.  Please use syntax `parent_collection.child_collections << child_collection` instead.  This has a target date for removal of 07-31-2015"
      parent_collection.child_collections << child_collection
    end

  end
end
