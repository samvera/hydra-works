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
    autoload :WorkBehavior,           'hydra/works/models/concerns/work_behavior'
    autoload :FileBehavior,           'hydra/works/models/concerns/file_behavior'


    # model validations
    def self.collection? collection
      return false unless collection.respond_to? :type
      collection.type.include? RDFVocabularies::WorksTerms.Collection
    end

    def self.generic_work? generic_work
      return false unless generic_work.respond_to? :type
      generic_work.type.include? RDFVocabularies::WorksTerms.GenericWork
    end

    def self.generic_file? generic_file
      return false unless generic_file.respond_to? :type
      generic_file.type.include? RDFVocabularies::WorksTerms.GenericFile
    end

  end
end
