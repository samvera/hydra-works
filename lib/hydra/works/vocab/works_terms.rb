require 'rdf'
module WorksVocabularies
  class WorksTerms < RDF::Vocabulary("http://projecthydra.org/works/models#")

    # Class definitions
    term :Collection
    term :GenericWork
    term :GenericFile
    term :File

  end
end
