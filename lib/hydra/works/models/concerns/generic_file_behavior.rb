module Hydra::Works
  # This module provides all of the Behaviors of a Hydra::Works::GenericFile
  #
  # behavior:
  #   1) Hydra::Works::GenericFile can contain (pcdm:hasFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
  #   2) Hydra::Works::GenericFile can contain (pcdm:hasRelatedFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
  #   3) Hydra::Works::GenericFile can aggregate (pcdm:hasMember) Hydra::Works::GenericFile
  #   4) Hydra::Works::GenericFile can NOT aggregate anything other than Hydra::Works::GenericFiles
  #   5) Hydra::Works::GenericFile can have descriptive metadata
  #   6) Hydra::Works::GenericFile can have access metadata
  module GenericFileBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::ObjectBehavior

    included do
      type [Hydra::PCDM::Vocab::PCDMTerms.Object, Vocab::WorksTerms.GenericFile]

      include Hydra::Works::GenericFile::ContainedFiles
      include Hydra::Works::GenericFile::Derivatives
      include Hydra::Works::GenericFile::MimeTypes
      include Hydra::Works::GenericFile::VersionedContent
      include Hydra::Works::BlockChildObjects
    end

    # @return [Boolean] whether this instance is a Hydra::Works Collection.
    def works_collection?
      false
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic Work.
    def works_generic_work?
      false
    end

    # @return [Boolean] whether this instance is a Hydra::Works Generic File.
    def works_generic_file?
      true
    end

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

    def generic_works
      warn '[DEPRECATION] `generic_works` is deprecated in Hydra::Works.  Please use `in_generic_works` instead.  This has a target date for removal of 10-31-2015'
      in_generic_works
    end
  end
end
