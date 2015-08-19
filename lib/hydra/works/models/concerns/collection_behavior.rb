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
      type [Hydra::PCDM::Vocab::PCDMTerms.Collection, Vocab::WorksTerms.Collection]
      include Hydra::Works::BlockChildObjects

      filters_association :members, as: :child_collections, condition: :works_collection?
      filters_association :members, as: :child_generic_works, condition: :works_generic_work?
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def works_collection?
      true
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def works_generic_work?
      false
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic File.
    def works_generic_file?
      false
    end

    def parents
      aggregated_by
    end

    def parent_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::CollectionBehavior) }
    end
  end
end
