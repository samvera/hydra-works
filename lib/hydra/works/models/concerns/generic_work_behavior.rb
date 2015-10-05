module Hydra::Works
  # @deprecated use Hydra::Works::WorkBehavior instead
  module GenericWorkBehavior
    extend ActiveSupport::Concern
    extend Deprecation
    self.deprecation_horizon = "Hydra::Works 0.4.0"
    included do
      Deprecation.warn self, "GenericWorkBehavior is deprecated. Use WorkBehavior instead. This module will be removed in Hydra::Works 0.4.0"
      include Hydra::Works::WorkBehavior
    end
  end
end
