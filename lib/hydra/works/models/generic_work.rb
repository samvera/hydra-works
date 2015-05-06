require 'active_fedora/aggregation'

module Hydra::Works
  class GenericWork < Hydra::PCDM::Object
    # TODO - should this be a whole new class or just additional behavioral concerns modules?
    include Hydra::Works::GenericWorkBehavior
  end
end

