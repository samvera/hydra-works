module Hydra::Works
  # This module provides all of the Behaviors of a Hydra::Works::Collection
  #
  # behavior:
  #   1) Hydra::Works::Collection can aggregate Hydra::Works::Collection
  #   2) Hydra::Works::Collection can aggregate Hydra::Works::Work

  #   3) Hydra::Works::Collection can NOT aggregate Hydra::PCDM::Collection unless it is also a Hydra::Works::Collection
  #   4) Hydra::Works::Collection can NOT aggregate Hydra::Works::FileSet
  #   5) Hydra::Works::Collection can NOT aggregate non-PCDM object
  #   6) Hydra::Works::Collection can NOT contain Hydra::PCDM::File
  #   7) Hydra::Works::Collection can NOT contain

  #   8) Hydra::Works::Collection can have descriptive metadata
  #   9) Hydra::Works::Collection can have access metadata
  module CollectionBehavior
    extend ActiveSupport::Concern
    extend Deprecation
    self.deprecation_horizon = "Hydra::Works 0.4.0"
    include Hydra::PCDM::CollectionBehavior

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Collection, Vocab::WorksTerms.Collection]
      include Hydra::Works::BlockChildObjects

      alias_method :generic_works, :works
      deprecation_deprecate :generic_works
    end

    def works
      members.select(&:work?)
    end

    def work_ids
      works.map(&:id)
    end

    def collections
      members.select(&:collection?)
    end

    def collection_ids
      collections.map(&:id)
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def collection?
      true
    end

    alias_method :works_collection?, :collection?
    deprecation_deprecate :works_collection?

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def work?
      false
    end

    alias_method :works_generic_work?, :work?
    deprecation_deprecate :works_generic_work?

    # @return [Boolean] whether this instance is a Hydra::Works::FileSet.
    def file_set?
      false
    end

    alias_method :works_generic_file?, :file_set?
    deprecation_deprecate :works_generic_file?

    def member_of
      aggregated_by
    end

    def parents
      Deprecation.warn CollectionBehavior, '`parents` is deprecated in Hydra::Works.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::CollectionBehavior) }
    end

    def parent_collections
      Deprecation.warn CollectionBehavior, '`parent_collections` is deprecated in Hydra::Works.  Please use `in_collections` instead.  This has a target date for removal of 10-31-2015'
      in_collections
    end

    def child_collections
      Deprecation.warn CollectionBehavior, '`child_collections` is deprecated in Hydra::Works.  Please use `collections` instead.  This has a target date for removal of 10-31-2015'
      collections
    end

    def child_collection_ids
      Deprecation.warn CollectionBehavior, '`child_collection_ids` is deprecated in Hydra::Works.  Please use `collection_ids` instead.  This has a target date for removal of 10-31-2015'
      collection_ids
    end

    def child_generic_works
      Deprecation.warn CollectionBehavior, '`child_generic_works` is deprecated in Hydra::Works.  Please use `works` instead.  This has a target date for removal of 10-31-2015'
      works
    end

    def child_generic_work_ids
      Deprecation.warn CollectionBehavior, '`child_generic_work_ids` is deprecated in Hydra::Works.  Please use `work_ids` instead.  This has a target date for removal of 10-31-2015'
      work_ids
    end
  end
end
