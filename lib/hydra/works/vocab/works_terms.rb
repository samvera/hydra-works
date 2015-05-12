require 'rdf'
module RDFVocabularies
  class WorksTerms < RDF::Vocabulary("http://hydra.org/works/models#")

    # Class definitions
    term :Collection
    term :GenericWork
    term :GenericFile
    term :File

  end
end
