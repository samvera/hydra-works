module Hydra::Works::Characterization
  module Base
    extend ActiveSupport::Concern

    included do
      # Apply the base schema. This will add properties defined in the schema.
      apply_schema BaseSchema, AlreadyThereStrategy

      # Parser config is :term => :property.
      # Use this config to override the default behavior of value assignment which is:
      # value is assigned to the property with the same name as the characterization term.
      # use parser_config.merge! for subsequent modules.
      class_attribute :parser_mapping
      self.parser_mapping = { exif_tool_version: :exif_version,
                              file_mime_type: :mime_type }

      # Parser class is an OM terminology.
      # It maps the characterization tool's output xml to terms and values.
      class_attribute :parser_class
      self.parser_class = FitsDatastream
    end
  end
end
