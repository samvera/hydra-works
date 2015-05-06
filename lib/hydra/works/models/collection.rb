require 'active_fedora/aggregation'

module Hydra::Works
  class Collection < Hydra::PCDM::Collection
    # TODO - should this be a whole new class or just additional behavioral concerns modules?
    include Hydra::Works::CollectionBehavior
  end
end

