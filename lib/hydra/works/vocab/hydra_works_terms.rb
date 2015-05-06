require 'rdf'
module RDFVocabularies
  class HydraWorksTerms < RDF::Vocabulary("http://pcdm.org/models/works#")

    # Class definitions
    term :Collection
    term :GenericWork
    term :GenericFile
    term :File

    # Property definitions
    property :hasMember
    property :hasFile
  end
end
