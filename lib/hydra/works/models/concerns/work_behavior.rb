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

    included do
      def self.type_validator
        Hydra::PCDM::Validators::CompositeValidator.new(
          Hydra::Works::NotCollectionValidator,
          super
        )
      end
      include Hydra::PCDM::ObjectBehavior
      before_destroy :remove_from_parents

      type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.Work]
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
      Deprecation.warn WorkBehavior, "ordered_file_sets is deprecated and will be removed in Hydra::Works 1.0. If you need order, use an interstitial work node."
      ordered_members.to_a.select(&:file_set?)
    end

    def ordered_file_set_ids
      Deprecation.warn WorkBehavior, "ordered_file_set_ids is deprecated and will be removed in Hydra::Works 1.0. If you need order, use an interstitial work node."
      ordered_file_sets.map(&:id)
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def collection?
      false
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def work?
      true
    end

    # @return [Boolean] whether this instance is a Hydra::Works::FileSet.
    def file_set?
      false
    end

    def in_works
      ordered_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::WorkBehavior) }.to_a
    end

    private

      # Remove this object from parent works or collections
      def remove_from_parents
        ordered_by.each do |parent|
          parent.ordered_members.delete(self) # Delete the list node
          parent.members.delete(self) # Delete the indirect container Proxy
          parent.save! # record the changes to the ordered members
        end
      end
  end
end
