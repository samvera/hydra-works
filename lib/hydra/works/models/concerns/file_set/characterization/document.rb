module Hydra::Works::Characterization
  module Document
    extend ActiveSupport::Concern

    included do
      # Apply the document schema. This will add properties defined in the schema.
      apply_schema DocumentSchema, AlreadyThereStrategy
    end
  end
end
