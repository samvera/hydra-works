require 'hydra/works/version'
require 'active_fedora/aggregation'
require 'hydra/pcdm'

module Hydra
  module Works

    # vocabularies
    autoload :RDFVocabularies,        'hydra/works/vocab/works_terms'

    # models
    autoload :Collection,             'hydra/works/models/collection'
    autoload :GenericWork,            'hydra/works/models/generic_work'
    autoload :GenericFile,            'hydra/works/models/generic_file'
    
    #behaviors
    autoload :CollectionBehavior,     'hydra/works/models/concerns/collection_behavior'
    autoload :GenericWorkBehavior,    'hydra/works/models/concerns/generic_work_behavior'
    autoload :GenericFileBehavior,    'hydra/works/models/concerns/generic_file_behavior'


    # model validations
    def self.collection? collection
      return false unless collection.respond_to? :type
      # collection.type.include? RDFVocabularies::WorksTerms.Collection

      # TODO check for works collection instead of pcdm collection   (see issue #71)
      Hydra::PCDM.collection? collection
    end

    def self.generic_work? generic_work
      return false unless generic_work.respond_to? :type
      # generic_work.type.include? RDFVocabularies::WorksTerms.GenericWork

      # TODO check for works generic_work instead of pcdm object  (see issue #71)
      Hydra::PCDM.object? generic_work
    end

    def self.generic_file? generic_file
      return false unless generic_file.respond_to? :type
      # generic_file.type.include? RDFVocabularies::WorksTerms.GenericFile

      # TODO check for works generic_work instead of pcdm object  (see issue #71)
      Hydra::PCDM.object? generic_file
    end

  end
end
