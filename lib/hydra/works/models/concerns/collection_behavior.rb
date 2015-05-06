module Hydra::Works
  module CollectionBehavior

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

    # TODO: Inherit members as a private method so setting objects on aggregations has to go through the following methods.
    # TODO: FIX: All of the following methods for aggregations are effected by the error "uninitialized constant Member".
    #       See collection_spec test for more information.

    def << arg
      # TODO: Not sure how to handle coll1.collections << new_collection.
      #       Want to override << on coll1.collections to check that new_collection is_a? Hydra::Works::Collection

      # TODO: Not sure how to handle coll1.generic_works << new_generic_work.
      #       Want to override << on coll1.generic_works to check that new_generic_work is_a? Hydra::Works::GenericWork

      # check that arg is an instance of Hydra::Works::Collection or Hydra::Works::GenericWorks
      raise ArgumentError, "argument must be either a Hydra::Works::Collection or Hydra::Works::GenericWork" unless
          arg.is_a?( Hydra::Works::Collection ) || arg.is_a?( Hydra::Works::GenericWork )
      members << arg
    end

    def collections= collections

      # TODO Should this just inherit from PCDM or is it significant to check for Hydra::Works::Collection instead of
      #      the inherited Hydra::PCDM::Collection

      # # check that each collection is an instance of Hydra::Works::Collection
      # raise ArgumentError, "each collection must be a Hydra::Works::Collection" unless
      #     collections.all? { |c| c is_a? Hydra::Works::Collection }
      # members = collections
    end

    def collections

      # TODO Should this just inherit from PCDM or is it significant to check for Hydra::Works::Collection instead of
      #      the inherited Hydra::PCDM::Collection

      # TODO: query fedora for collection id && hasMember && rdf_type == RDFVocabularies::HydraWorksTerms.Collection
    end

    def generic_works works

      # check that object is an instance of Hydra::Works::GenericWork
      raise ArgumentError, "each object must be a Hydra::Works::GenericWork" unless
          works.all? { |o| o is_a? Hydra::Works::GenericWork }
      members = works
    end

    def generic_works
      # TODO: query fedora for collection id && hasMember && rdf_type == RDFVocabularies::HydraWorksTerms.Object
    end

    # TODO: Not sure how to handle coll1.generic_works << new_work.
    #       Want to override << on coll1.generic_works to check that new_work is_a? Hydra::Works::GenericWork


    # def contains  # TODO Need to remove this.  Inherit this behavior from Hydra::PCDM::Collection.
    #   # always raise an error because contains is not an allowed behavior
    #   raise NoMethodError, "undefined method `contains' for :Hydra::Works::Collection"
    # end

    # TODO: RDF metadata can be added using property definitions. -- inherit from Hydra::PCDM::Collection???
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end

