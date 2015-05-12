module Hydra::Works
  class File < Hydra::PCDM::File

    # Need this here until projecthydra-labs/hydra-pcdm#77 is closed
    metadata do
      configure type: RDFVocabularies::PCDMTerms.File
      property :label, predicate: ::RDF::RDFS.label
    end

    # We can use PCDM vocab class when projecthydra-labs/hydra-pcdm#80 is merged

    def original_file= content
      self.content = content
      self.metadata_node.type = ::RDF::URI("http://pcdm.org/OriginalFile")
      self.save
    end

    def thumbnail= content
      self.content = content
      self.metadata_node.type = ::RDF::URI("http://pcdm.org/ThumbnailImage")
      self.save
    end

    def extracted_text= content
      self.content = content
      self.metadata_node.type = ::RDF::URI("http://pcdm.org/ExtractedText")
      self.save
    end

  end
end
