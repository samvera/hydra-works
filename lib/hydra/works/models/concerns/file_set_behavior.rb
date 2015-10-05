module Hydra::Works
  # This module provides all of the Behaviors of a Hydra::Works::GenericFile
  #
  # behavior:
  #   1) Hydra::Works::FileSet can contain (pcdm:hasFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
  #   2) Hydra::Works::FileSet can contain (pcdm:hasRelatedFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
  #   3) Hydra::Works::FileSet can aggregate (pcdm:hasMember) Hydra::Works::FileSet
  #   4) Hydra::Works::FileSet can NOT aggregate anything other than Hydra::Works::FileSets
  #   5) Hydra::Works::FileSet can have descriptive metadata
  #   6) Hydra::Works::FileSet can have access metadata
  module FileSetBehavior
    extend ActiveSupport::Concern
    extend Deprecation
    self.deprecation_horizon = "Hydra::Works 0.4.0"
    include Hydra::PCDM::ObjectBehavior

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.FileSet]

      include Hydra::Works::ContainedFiles
      include Hydra::Works::Derivatives
      include Hydra::Works::MimeTypes
      include Hydra::Works::VersionedContent
      include Hydra::Works::BlockChildObjects
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def collection?
      false
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
      true
    end

    alias_method :works_generic_file?, :file_set?
    deprecation_deprecate :works_generic_file?

    def member_of
      aggregated_by
    end

    def parents
      Deprecation.warn GenericFileBehavior, '`parents` is deprecated in Hydra::Works.  Please use `member_of` instead.  This has a target date for removal of 10-31-2015'
      member_of
    end

    def in_works
      aggregated_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::WorkBehavior) }
    end

    alias_method :in_generic_works, :in_works
    deprecation_deprecate :in_generic_works

    def generic_works
      Deprecation.warn GenericFileBehavior, '`generic_works` is deprecated in Hydra::Works.  Please use `in_works` instead.  This has a target date for removal of 10-31-2015'
      in_works
    end
  end
end
