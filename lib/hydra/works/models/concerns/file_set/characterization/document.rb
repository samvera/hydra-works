module Hydra::Works::Characterization
  module Document
    extend ActiveSupport::Concern

    autoload :DocumentSchema, 'hydra/works/models/characterization/document_schema.rb'

    included do
      # Apply the document schema. This will add properties defined in the schema.
      apply_schema DocumentSchema, AlreadyThereStrategy
    end
  end
end
