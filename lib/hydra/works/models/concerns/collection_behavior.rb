module Hydra::Works
  module CollectionBehavior
    extend ActiveSupport::Concern
    include Hydra::PCDM::CollectionBehavior 

    # included do
    #   type RDFVocabularies::WorksTerms.Collection
    # end

    def initialize(*args)
      super(*args)

      t = get_values(:type)
      t << RDFVocabularies::WorksTerms.Collection
      set_value(:type,t)
    end

    # TODO: Is there a separate HydraWorks ontology or are works terms and properties defined in PCDM ontology?
    # TODO: Extend rdf type to include HydraWorks.Collection

    # behavior:
    #   NOTE: Hydra::PCDM::Collection can aggregate Hydra::Works::Collection because Hydra::Works::Collection inherits
    #         from Hydra::PCDM::Collection  TODO: Need to test this.
    #   1) Hydra::Works::Collection can NOT aggregate Hydra::PCDM::Collection unless it is also a Hydra::Works::Collection
    #   2) Hydra::Works::Collection can aggregate Hydra::Works::Collection
    #   3) Hydra::Works::Collection can aggregate Hydra::Works::GenericWork
    #   4) Hydra::Works::Collection can NOT aggregate Hydra::Works::GenericFile
    #   5) Hydra::Works::Collection can NOT aggregate non-PCDM object
    #   6) Hydra::Works::Collection can NOT contain Hydra::PCDM::File
    #   7) Hydra::Works::Collection can NOT contain Hydra::Works::File
    #   8) Hydra::Works::Collection can have descriptive metadata
    #   9) Hydra::Works::Collection can have access metadata
    # TODO: add code to enforce behavior rules


    def collections= collections
      raise ArgumentError, "each collection must be a Hydra::Works::Collection" unless collections.all? { |c| Hydra::Works.collection? c }
      raise ArgumentError, "a collection can't be an ancestor of itself" if collection_ancestor?(collections)
      self.members = self.objects + collections
    end

    def collections
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::Works.collection? m }
    end

    def generic_works= generic_works
      raise ArgumentError, "each generic_work must be a hydra works generic work" unless generic_works.all? { |w| Hydra::Works.generic_work? w }
      self.members = self.collections + generic_works
    end

    def generic_works
      all_members = self.members.container.to_a
      all_members.select { |m| Hydra::Works.generic_work? m }
    end

    # TODO: RDF metadata can be added using property definitions. -- inherit from Hydra::PCDM::Collection???
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end
