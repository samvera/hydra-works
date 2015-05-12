require 'rdf'
module RDFVocabularies
  class WorksTerms < RDF::Vocabulary("http://hydra.org/works/models#")

    # TODO switch to using generated vocabulary when ready; Then delete this file.


    # Class definitions
    term :Collection
    term :GenericWork
    term :GenericFile
    term :File

    # Property definitions
    property :hasMember
    property :hasFile
    property :hasRelatedFile
  end
end
