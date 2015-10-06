module Hydra::Works
  # @deprecated use FileSetBehavior instead
  module GenericFileBehavior
    extend ActiveSupport::Concern
    extend Deprecation

    included do
      Deprecation.warn GenericFileBehavior, "GenericFileBehavior is deprecated. Use FileSetBehavior instead. This will be removed in Hydra::Works 0.4.0"
      include FileSetBehavior
    end
  end
end
