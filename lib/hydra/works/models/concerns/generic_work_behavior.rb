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
    extend Deprecation
    self.deprecation_horizon = "Hydra::Works 0.4.0"
    include Hydra::PCDM::ObjectBehavior

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.GenericWork]
      include Hydra::Works::BlockChildObjects

      filters_association :members, as: :generic_works, condition: :generic_work?
      filters_association :members, as: :generic_files, condition: :generic_file?
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def collection?
      false
    end

    alias_method :works_collection?, :collection?
    deprecation_deprecate :works_collection?

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def generic_work?
      true
    end

    alias_method :works_generic_work?, :generic_work?
    deprecation_deprecate :works_generic_work?

    # @return [Boolean] whether this instance is a Hydra::Works Generic File.
    def generic_file?
      false
    end

    alias_method :works_generic_file?, :generic_file?
    deprecation_deprecate :works_generic_file?

    def member_of
      aggregated_by
    end

    def parents
      warn '[DEPRECATION] `parents` is deprecated in Hydra::Works.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_generic_works
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::GenericWorkBehavior) }
    end

    def parent_generic_works
      warn '[DEPRECATION] `parent_generic_works` is deprecated in Hydra::Works.  Please use `in_generic_works` instead.  This has a target date for removal of 10-31-2015'
      in_generic_works
    end

    def in_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::CollectionBehavior) }
    end

    def parent_collections
      warn '[DEPRECATION] `parent_collections` is deprecated in Hydra::Works.  Please use `in_collections` instead.  This has a target date for removal of 10-31-2015'
      in_collections
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
