module Hydra::Works::Characterization
  module Audio
    extend ActiveSupport::Concern

    included do
      # Apply the audio schema. This will add properties defined in the schema.
      apply_schema AudioSchema, AlreadyThereStrategy

      # Update the configuration to map the parsed terms to the correct property.
      parser_mapping.merge!(audio_sample_rate: :sample_rate,
                            audio_duration: :duration)
    end
  end
end
