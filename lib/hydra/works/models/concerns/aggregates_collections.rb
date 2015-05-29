module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works collections
  module AggregatesCollections

    def collections= collections
      raise ArgumentError, "each collection must be a hydra works collection" unless collections.all? { |c| Hydra::Works.collection? c }
      raise ArgumentError, "a collection can't be an ancestor of itself" if collection_ancestor?(collections)
      self.members = self.generic_works + collections
    end

    def collections
      members.to_a.select { |m| Hydra::Works.collection? m }
    end

  end
end
