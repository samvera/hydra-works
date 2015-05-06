module Hydra::Works
  module GenericFile
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

    # def files( file )
    #   # check that file is an instance of Hydra::Works::File
    #   contains << file  if object is_a? Hydra::Works::File
    # end

    # TODO: RDF metadata can be added using property definitions.
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Object's descriptive metadata?
    #   * Are there any default properties to set for Object's access metadata?
    #   * Is there a way to override default properties defined in this class?






    # TODO: Inherit members as a private method so setting objects on aggregations has to go through the following methods.
    # TODO: FIX: All of the following methods for aggregations are effected by the error "uninitialized constant Member".
    #       See collection_spec test for more information.

    def << arg
      # check that arg is an instance of Hydra::Works::File or Hydra::Works::GenericFile
      raise ArgumentError, "argument must be either a Hydra::Works::GenericWork or Hydra::Works::GenericFile" unless
          arg.is_a?( Hydra::Works::GenericWork ) || arg.is_a?( Hydra::Works::GenericFile )
      members << arg
    end


    def generic_works= works
      # check that work is an instance of Hydra::Works::GenericWork
      raise ArgumentError, "each work must be a Hydra::Works::GenericWork" unless
          works.all? { |o| o is_a? Hydra::Works::GenericWork }
      members = works
    end

    def generic_works
      # TODO: query fedora for generic work id && hasMember && rdf_type == RDFVocabularies::HydraWorksTerms.GenericWork
    end

    # TODO: Not sure how to handle work1.generic_works << new_work.
    #       Want to override << on work1.generic_works to check that new_work is_a? Hydra::Works::GenericWork


    def generic_files= files
      # check that work is an instance of Hydra::Works::GenericFile
      raise ArgumentError, "each file must be a Hydra::Works::GenericFile" unless
          files.all? { |o| o is_a? Hydra::Works::GenericFile }
      members = files
    end

    def generic_files
      # TODO: query fedora for generic file id && hasMember && rdf_type == RDFVocabularies::HydraWorksTerms.GenericFile
    end

    # TODO: Not sure how to handle work1.generic_files << new_file.
    #       Want to override << on work1.generic_files to check that new_file is_a? Hydra::Works::GenericFile


    def contains
      # always raise an error because contains is not an allowed behavior
      raise NoMethodError, "undefined method `contains' for :Hydra::Works::GenericWork"
    end


    # TODO: RDF metadata can be added using property definitions. -- inherit from Hydra::PCDM::Collection???
    #   * How to distinguish between descriptive and access metadata?
    #   * Are there any default properties to set for Collection's descriptive metadata?
    #   * Are there any default properties to set for Collection's access metadata?
    #   * Is there a way to override default properties defined in this class?

  end
end

