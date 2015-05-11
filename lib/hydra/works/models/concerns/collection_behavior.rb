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

    # TODO Need allow both generic works and collections to 
    # def collections= collections
    #   raise ArgumentError, "each collection must be a Hydra::Works::Collection" unless 
    #       collections.all? { |c| c.is_a? Hydra::Works::Collection }
    #   self.members = self.generic_works + collections
    # end

    # def collections

    #   # TODO Should this just inherit from PCDM or is it significant to check for Hydra::Works::Collection instead of
    #   #      the inherited Hydra::PCDM::Collection

    #   # TODO: query fedora for collection id && hasMember && rdf_type == RDFVocabularies::HydraWorksTerms.Collection
    # end

    def generic_works= works
      # check that object is an instance of Hydra::Works::GenericWork
      raise ArgumentError, "each object must be a Hydra::Works::GenericWork" unless
          works.all? { |o| o.is_a? Hydra::Works::GenericWork }
      self.members = works
    end

    def generic_works
      # TODO: query fedora for collection id && hasMember && rdf_type == RDFVocabularies::HydraWorksTerms.Object
      self.members
    end

    # TODO: RDF metadata can be added using property definitions. -- inherit from Hydra::PCDM::Collection???
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end
