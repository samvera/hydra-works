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

    def in_works
      ordered_by.select { |parent| parent.class.included_modules.include?(Hydra::Works::WorkBehavior) }.to_a
    end

    alias_method :in_generic_works, :in_works
    deprecation_deprecate :in_generic_works
  end
end
