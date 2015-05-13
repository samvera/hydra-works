require 'hydra/works/version'
require 'active_fedora/aggregation'
require 'hydra/pcdm'

module Hydra
  module Works

    # vocabularies
    autoload :WorksVocabularies,      'hydra/works/vocab/works_terms'

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
      collection.type.include? WorksVocabularies::WorksTerms.Collection
    end

    def self.generic_work? generic_work
      return false unless generic_work.respond_to? :type
      generic_work.type.include? WorksVocabularies::WorksTerms.GenericWork
    end

    def self.generic_file? generic_file
      return false unless generic_file.respond_to? :type
      generic_file.type.include? WorksVocabularies::WorksTerms.GenericFile
    end

  end
end
