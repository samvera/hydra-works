module Hydra::Works
  # This module provides all of the Behaviors of a Hydra::Works::Work
  #
  # behavior:
  #   1) Hydra::Works::Work can aggregate Hydra::Works::Work
  #   2) Hydra::Works::Work can aggregate Hydra::Works::FileSet
  #   3) Hydra::Works::Work can NOT aggregate Hydra::PCDM::Collection
  #   4) Hydra::Works::Work can NOT aggregate Hydra::Works::Collection
  #   5) Hydra::Works::Work can NOT aggregate Works::Object unless it is also a Hydra::Works::FileSet
  #   6) Hydra::Works::Work can NOT contain PCDM::File
  #   7) Hydra::Works::Work can NOT aggregate non-PCDM object
  #   8) Hydra::Works::Work can NOT contain Hydra::Works::FileSet
  #   9) Hydra::Works::Work can have descriptive metadata
  #   10) Hydra::Works::Work can have access metadata
  module WorkBehavior
    extend ActiveSupport::Concern
    extend Deprecation
    self.deprecation_horizon = "Hydra::Works 0.4.0"
    include Hydra::PCDM::ObjectBehavior

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.Work]

      alias_method :generic_works, :ordered_works
      deprecation_deprecate :generic_works

      alias_method :generic_files, :ordered_file_sets
    end

    def works
      members.select(&:work?)
    end

    def work_ids
      works.map(&:id)
    end

    def ordered_works
      ordered_members.to_a.select(&:work?)
    end

    def ordered_work_ids
      ordered_works.map(&:id)
    end

    def file_sets
      members.select(&:file_set?)
    end

    def file_set_ids
      file_sets.map(&:id)
    end

    def ordered_file_sets
      ordered_members.to_a.select(&:file_set?)
    end

    def ordered_file_set_ids
      ordered_file_sets.map(&:id)
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def collection?
      false
    end

    alias_method :works_collection?, :collection?
    deprecation_deprecate :works_collection?

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def work?
      true
    end

    alias_method :works_generic_work?, :work?
    deprecation_deprecate :works_generic_work?

    # @return [Boolean] whether this instance is a Hydra::Works::FileSet.
    def file_set?
      false
    end

    alias_method :works_generic_file?, :file_set?
    deprecation_deprecate :works_generic_file?

    def parents
      Deprecation.warn WorkBehavior, '`parents` is deprecated in Hydra::Works.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_works
      ordered_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::WorkBehavior) }.to_a
    end

    alias_method :in_generic_works, :in_works
    deprecation_deprecate :in_generic_works

    def parent_generic_works
      Deprecation.warn WorkBehavior, '`parent_generic_works` is deprecated in Hydra::Works.  Please use `in_works` instead.  This has a target date for removal of 10-31-2015'
      in_works
    end

    def parent_collections
      Deprecation.warn WorkBehavior, '`parent_collections` is deprecated in Hydra::Works.  Please use `in_collections` instead.  This has a target date for removal of 10-31-2015'
      in_collections
    end

    def child_generic_works
      Deprecation.warn WorkBehavior, '`child_generic_works` is deprecated in Hydra::Works.  Please use `ordered_works` instead.  This has a target date for removal of 10-31-2015'
      ordered_works
    end

    def child_generic_work_ids
      Deprecation.warn WorkBehavior, '`child_generic_work_ids` is deprecated in Hydra::Works.  Please use `ordered_work_ids` instead.  This has a target date for removal of 10-31-2015'
      ordered_work_ids
    end
  end
end
