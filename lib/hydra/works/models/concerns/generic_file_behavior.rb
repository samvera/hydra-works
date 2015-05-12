module Hydra::Works
  module GenericFileBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::ObjectBehavior

    # TODO: Extend rdf type to include RDFVocabularies::HydraWorks.GenericFile   (see issue #71)
    # included do
    #   type RDFVocabularies::WorksTerms.GenericFile
    # end

    # behavior:
    #   1) Hydra::Works::GenericFile can contain (pcdm:hasFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
    #   2) Hydra::Works::GenericFile can contain (pcdm:hasRelatedFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
    #   3) Hydra::Works::GenericFile can aggregate (pcdm:hasMember) Hydra::Works::GenericFile

    #   4) Hydra::Works::GenericFile can NOT aggregate anything else

    #   5) Hydra::Works::GenericFile can have descriptive metadata
    #   6) Hydra::Works::GenericFile can have access metadata



    # TODO: Not sure how to handle work1.generic_files << new_generic_file.  (see issue #45)
    #       Want to override << on work1.generic_files to check that new_work Hydra::Works.generic_file?


    def generic_files= generic_files
      raise ArgumentError, "each generic_file must be a hydra works generic file" unless generic_files.all? { |w| Hydra::Works.generic_file? w }
      raise ArgumentError, "a generic file can't be an ancestor of itself" if object_ancestor?(generic_files)
      self.members = generic_files
    end

    def generic_files
      members.to_a.select { |m| Hydra::Works.generic_file? m }
    end

  end
end
