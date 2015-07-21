module Hydra::Works
  class RemoveCollectionFromCollection

    ##
    # Remove a collection from a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection from which to remove collection
    # @param [Hydra::Works::Collection] :child_collection being removed
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_collection )
      warn "[DEPRECATION] `Hydra::Works::RemoveCollectionFromCollection` is deprecated.  Please use syntax `parent_collection.child_collections.delete child_collection` instead which returns [child_collection] instead of child_collection.  This has a target date for removal of 07-31-2015"
      result = parent_collection.child_collections.delete child_collection
      result = result.first if result.kind_of?(Array) && result.size >= 1      # temporarily done for compatibility with current service object API
      result

      # TODO FIX when members is empty, members.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #35)
    end
  end
end
