module Hydra::Works
  # This module provides all of the Behaviors of a Hydra::Works::Work
  #
  # behavior:
  #   1) Hydra::Works::Work can aggregate Hydra::Works::Work
  #   2) Hydra::Works::Work can aggregate Hydra::Works::GenericFile
  #   3) Hydra::Works::Work can NOT aggregate Hydra::PCDM::Collection
  #   4) Hydra::Works::Work can NOT aggregate Hydra::Works::Collection
  #   5) Hydra::Works::Work can NOT aggregate Works::Object unless it is also a Hydra::Works::GenericFile
  #   6) Hydra::Works::Work can NOT contain PCDM::File
  #   7) Hydra::Works::Work can NOT aggregate non-PCDM object
  #   8) Hydra::Works::Work can NOT contain Hydra::Works::GenericFile
  #   9) Hydra::Works::Work can have descriptive metadata
  #   10) Hydra::Works::Work can have access metadata
  module WorkBehavior
    extend ActiveSupport::Concern
    extend Deprecation
    self.deprecation_horizon = "Hydra::Works 0.4.0"
    include Hydra::PCDM::ObjectBehavior

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.Work]
      include Hydra::Works::BlockChildObjects

      filters_association :members, as: :works, condition: :work?
      filters_association :members, as: :generic_files, condition: :generic_file?

      alias_method :generic_works, :works
      alias_method :generic_works=, :works=
      deprecation_deprecate :generic_works, :generic_works=
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
      Deprecation.warn WorkBehavior, '`parents` is deprecated in Hydra::Works.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_works
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::WorkBehavior) }
    end

    alias_method :in_generic_works, :in_works
    deprecation_deprecate :in_generic_works

    def parent_generic_works
      Deprecation.warn WorkBehavior, '`parent_generic_works` is deprecated in Hydra::Works.  Please use `in_works` instead.  This has a target date for removal of 10-31-2015'
      in_works
    end

    def in_collections
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::CollectionBehavior) }
    end

    def parent_collections
      Deprecation.warn WorkBehavior, '`parent_collections` is deprecated in Hydra::Works.  Please use `in_collections` instead.  This has a target date for removal of 10-31-2015'
      in_collections
    end

    def child_generic_works
      Deprecation.warn WorkBehavior, '`child_generic_works` is deprecated in Hydra::Works.  Please use `works` instead.  This has a target date for removal of 10-31-2015'
      works
    end

    def child_generic_works=(new_generic_works)
      Deprecation.warn WorkBehavior, '`child_generic_works=` is deprecated in Hydra::Works.  Please use `works=` instead.  This has a target date for removal of 10-31-2015'
      self.works = new_generic_works
    end

    def child_generic_work_ids
      Deprecation.warn WorkBehavior, '`child_generic_work_ids` is deprecated in Hydra::Works.  Please use `work_ids` instead.  This has a target date for removal of 10-31-2015'
      work_ids
    end
  end
end
