module Hydra::Works
  # This module provides all of the Behaviors of a Hydra::Works::GenericWork
  #
  # behavior:
  #   1) Hydra::Works::GenericWork can aggregate Hydra::Works::GenericWork
  #   2) Hydra::Works::GenericWork can aggregate Hydra::Works::GenericFile
  #   3) Hydra::Works::GenericWork can NOT aggregate Hydra::PCDM::Collection
  #   4) Hydra::Works::GenericWork can NOT aggregate Hydra::Works::Collection
  #   5) Hydra::Works::GenericWork can NOT aggregate Works::Object unless it is also a Hydra::Works::GenericFile
  #   6) Hydra::Works::GenericWork can NOT contain PCDM::File
  #   7) Hydra::Works::GenericWork can NOT aggregate non-PCDM object
  #   8) Hydra::Works::GenericWork can NOT contain Hydra::Works::GenericFile
  #   9) Hydra::Works::GenericWork can have descriptive metadata
  #   10) Hydra::Works::GenericWork can have access metadata
  module GenericWorkBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::ObjectBehavior

    included do
      type [RDFVocabularies::PCDMTerms.Object,WorksVocabularies::WorksTerms.GenericWork]
      include Hydra::Works::AggregatesGenericFiles
      include Hydra::Works::AggregatesGenericWorks
    end

    def contains= files
      raise NoMethodError, "works can not directly contain files.  You must add a GenericFile to the work's members and add files to that GenericFile."
    end

  end
end