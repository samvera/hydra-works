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
      include Hydra::Works::BlockChildObjects

      filters_association :members, as: :child_generic_works, condition: :works_generic_work?
      filters_association :members, as: :generic_files, condition: :works_generic_file?
    end

    def contains= files
      raise NoMethodError, "works can not directly contain files.  You must add a GenericFile to the work's members and add files to that GenericFile."
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def works_collection?
      false
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def works_generic_work?
      true
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic File.
    def works_generic_file?
      false
    end

    def parents
      aggregated_by
    end

    def parent_generic_works
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::GenericWorkBehavior) }
    end

    def parent_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::CollectionBehavior) }
    end

  end
end
