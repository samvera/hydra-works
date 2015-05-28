module Hydra::Works

  # This module provides all of the Behaviors of a Hydra::Works::Collection
  #
  # behavior:
  #   1) Hydra::Works::Collection can aggregate Hydra::Works::Collection
  #   2) Hydra::Works::Collection can aggregate Hydra::Works::GenericWork

  #   3) Hydra::Works::Collection can NOT aggregate Hydra::PCDM::Collection unless it is also a Hydra::Works::Collection
  #   4) Hydra::Works::Collection can NOT aggregate Hydra::Works::GenericFile
  #   5) Hydra::Works::Collection can NOT aggregate non-PCDM object
  #   6) Hydra::Works::Collection can NOT contain Hydra::PCDM::File
  #   7) Hydra::Works::Collection can NOT contain

  #   8) Hydra::Works::Collection can have descriptive metadata
  #   9) Hydra::Works::Collection can have access metadata
  module CollectionBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::CollectionBehavior

    included do
      type [RDFVocabularies::PCDMTerms.Collection,WorksVocabularies::WorksTerms.Collection]
      include Hydra::Works::AggregatesGenericWorks
      include Hydra::Works::AggregatesCollections
    end

  end
end
