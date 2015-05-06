module Hydra::Works
  class File < Hydra::PCDM::File
    # TODO: Extend rdf type to include RDFVocabularies::HydraWorks.File

    # behavior:
    #   1) Hydra::Works::File can NOT aggregate anything
    #   2) Hydra::Works::File can NOT contain Hydra::PCDM::File
    #   3) Hydra::Works::File can NOT contain Hydra::Works::File
    #   4) Hydra::Works::File can have technical metadata about one uploaded binary file
    # TODO: add code to enforce behavior rules

    # TODO: The only expected additional behavior for PCDM::File beyond ActiveFedora::File is the expression
    #       of additional technical metadata

  end
end

