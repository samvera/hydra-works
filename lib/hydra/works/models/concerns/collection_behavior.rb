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

      filters_association :members, as: :collections, condition: :works_collection?
      filters_association :members, as: :generic_works, condition: :works_generic_work?
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

    def member_of
      aggregated_by
    end

    def parents
      warn '[DEPRECATION] `parents` is deprecated in Hydra::Works.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::CollectionBehavior) }
    end

    def parent_collections
      warn '[DEPRECATION] `parent_collections` is deprecated in Hydra::Works.  Please use `in_collections` instead.  This has a target date for removal of 10-31-2015'
      in_collections
    end

    def child_collections
      warn '[DEPRECATION] `child_collections` is deprecated in Hydra::Works.  Please use `collections` instead.  This has a target date for removal of 10-31-2015'
      collections
    end

    def child_collections=(new_collections)
      warn '[DEPRECATION] `child_collections=` is deprecated in Hydra::Works.  Please use `collections=` instead.  This has a target date for removal of 10-31-2015'
      self.collections = new_collections
    end

    def child_collection_ids
      warn '[DEPRECATION] `child_collection_ids` is deprecated in Hydra::Works.  Please use `collection_ids` instead.  This has a target date for removal of 10-31-2015'
      collection_ids
    end

    def child_generic_works
      warn '[DEPRECATION] `child_generic_works` is deprecated in Hydra::Works.  Please use `generic_works` instead.  This has a target date for removal of 10-31-2015'
      generic_works
    end

    def child_generic_works=(new_generic_works)
      warn '[DEPRECATION] `child_generic_works=` is deprecated in Hydra::Works.  Please use `generic_works=` instead.  This has a target date for removal of 10-31-2015'
      self.generic_works = new_generic_works
    end

    def child_generic_work_ids
      warn '[DEPRECATION] `child_generic_work_ids` is deprecated in Hydra::Works.  Please use `generic_work_ids` instead.  This has a target date for removal of 10-31-2015'
      generic_work_ids
    end
  end
end
