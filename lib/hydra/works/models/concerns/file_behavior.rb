module Hydra::Works
  module FileBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::ObjectBehavior

    # included do
    #   type RDFVocabularies::WorksTerms.GenericFile
    # end

    def initialize(*args)
      super(*args)

      t = get_values(:type)
      t << RDFVocabularies::WorksTerms.GenericFile
      set_value(:type,t)
    end


    # TODO: Extend rdf type to include RDFVocabularies::HydraWorks.GenericFile

    # behavior:
    #   1) Hydra::Works::GenericFile can NOT aggregate anything
    #   2) Hydra::Works::GenericFile can NOT aggregate Hydra::Works::Collection
    #   3) Hydra::Works::GenericFile can NOT aggregate PCDM::Object unless it is also a Hydra::Works::GenericFile
    #   4) Hydra::Works::GenericFile can NOT aggregate Hydra::Works::GenericFile
    #   5) Hydra::Works::GenericFile can contain PCDM::File
    #   6) Hydra::Works::GenericFile can contain Hydra::Works::File
    #   7) Hydra::Works::GenericFile can NOT aggregate non-PCDM object
    #   8) Hydra::Works::GenericFile can have descriptive metadata
    #   9) Hydra::Works::GenericFile can have access metadata
    # TODO: add code to enforce behavior rules

    def generic_works= generic_works
      raise ArgumentError, "each generic_work must be a hydra works generic work" unless generic_works.all? { |w| Hydra::Works.generic_work? w }
      self.members = self.collections + generic_works
    end

    def generic_works
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::Works.generic_work? m }
    end

    def generic_files= generic_files
      raise ArgumentError, "each generic_file must be a hydra files generic file" unless generic_files.all? { |w| Hydra::Works.generic_file? w }
      self.members = self.collections + generic_files
    end

    def generic_files
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::Works.generic_file? m }
    end


    # TODO: RDF metadata can be added using property definitions. -- inherit from Hydra::PCDM::Collection???
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end
