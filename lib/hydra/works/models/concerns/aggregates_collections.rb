module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works collections
  module AggregatesCollections

    def child_collection_ids
      child_collections.map(&:id)
    end

    def collections= collections
      warn "[DEPRECATION] `collections=` is deprecated.  Please use `child_collections=` instead.  This has a target date for removal of 07-31-2015"
      self.child_collections = collections
    end

    def collections
      warn "[DEPRECATION] `collections` is deprecated.  Please use `child_collections` instead.  This has a target date for removal of 07-31-2015"
      self.child_collections
    end

  end
end
