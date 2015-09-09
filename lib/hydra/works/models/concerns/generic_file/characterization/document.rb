module Hydra::Works::GenericFile::Characterization
  module Document
    extend ActiveSupport::Concern

    autoload :DocumentSchema, 'hydra/works/models/generic_file/characterization/document_schema.rb'

    included do
      # Apply the document schema. This will add properties defined in the schema.
      apply_schema DocumentSchema, AlreadyThereStrategy

      # Update the configuration to map the parsed terms to the correct property.
      parser_config.merge!(file_title: :title,
                           file_author: :author)
    end
  end
end
