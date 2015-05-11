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

    # TODO: Make members private so setting objects on aggregations has to go through the following methods.

    # def generic_files( object)
    #   # check that object is an instance of Hydra::Works::GenericFile
    #   members << object  if object is_a? Hydra::Works::GenericFile
    # end

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Object's descriptive metadata?
    #   * Are there any default properties to set for Object's access metadata?
    #   * Is there a way to override default properties defined in this class?

    # TODO: Inherit members as a private method so setting objects on aggregations has to go through the following methods.
    # TODO: FIX: All of the following methods for aggregations are effected by the error "uninitialized constant Member".
    #       See collection_spec test for more information.

    # TODO: RDF metadata can be added using property definitions. -- inherit from Hydra::PCDM::Collection???
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end
