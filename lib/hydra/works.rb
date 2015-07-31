require 'hydra/works/version'
require 'active_fedora/aggregation'
require 'hydra/pcdm'
require 'hydra/derivatives'
require 'hydra/works/processor'

module Hydra
  module Works
    extend ActiveSupport::Autoload

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
    autoload :AggregatesGenericFiles, 'hydra/works/models/concerns/aggregates_generic_files'
    autoload :AggregatesGenericWorks, 'hydra/works/models/concerns/aggregates_generic_works'
    autoload :AggregatesCollections,  'hydra/works/models/concerns/aggregates_collections'
    autoload :GenericFile,            'hydra/works/models/generic_file'
    autoload :BlockChildObjects,      'hydra/works/models/concerns/block_child_objects'

    # collection services
    autoload :AddCollectionToCollection,           'hydra/works/services/collection/add_collection'
    autoload :AddGenericWorkToCollection,          'hydra/works/services/collection/add_generic_work'
    autoload :AddRelatedObjectToCollection,        'hydra/works/services/collection/add_related_object'
    autoload :GetCollectionsFromCollection,        'hydra/works/services/collection/get_collections'
    autoload :GetGenericWorksFromCollection,       'hydra/works/services/collection/get_generic_works'
    autoload :GetRelatedObjectsFromCollection,     'hydra/works/services/collection/get_related_objects'
    autoload :RemoveCollectionFromCollection,      'hydra/works/services/collection/remove_collection'
    autoload :RemoveGenericWorkFromCollection,     'hydra/works/services/collection/remove_generic_work'
    autoload :RemoveRelatedObjectFromCollection,   'hydra/works/services/collection/remove_related_object'

    # generic_work services
    autoload :AddGenericWorkToGenericWork,         'hydra/works/services/generic_work/add_generic_work'
    autoload :AddGenericFileToGenericWork,         'hydra/works/services/generic_work/add_generic_file'
    autoload :AddRelatedObjectToGenericWork,       'hydra/works/services/generic_work/add_related_object'
    autoload :GetGenericWorksFromGenericWork,      'hydra/works/services/generic_work/get_generic_works'
    autoload :GetGenericFilesFromGenericWork,      'hydra/works/services/generic_work/get_generic_files'
    autoload :GetRelatedObjectsFromGenericWork,    'hydra/works/services/generic_work/get_related_objects'
    autoload :MoveGenericFileToGenericWork,        'hydra/works/services/generic_work/move_generic_file'
    autoload :RemoveGenericWorkFromGenericWork,    'hydra/works/services/generic_work/remove_generic_work'
    autoload :RemoveGenericFileFromGenericWork,    'hydra/works/services/generic_work/remove_generic_file'
    autoload :RemoveRelatedObjectFromGenericWork,  'hydra/works/services/generic_work/remove_related_object'

    # generic_file services
    autoload_under 'services/generic_file' do
      autoload :AddFileToGenericFile
    end
    autoload :AddGenericFileToGenericFile,         'hydra/works/services/generic_file/add_generic_file'
    autoload :AddRelatedObjectToGenericFile,       'hydra/works/services/generic_file/add_related_object'
    autoload :GetGenericWorksFromGenericFile,      'hydra/works/services/generic_file/get_generic_works'
    autoload :GetGenericFilesFromGenericFile,      'hydra/works/services/generic_file/get_generic_files'
    autoload :GetRelatedObjectsFromGenericFile,    'hydra/works/services/generic_file/get_related_objects'
    autoload :RemoveGenericFileFromGenericFile,    'hydra/works/services/generic_file/remove_generic_file'
    autoload :RemoveRelatedObjectFromGenericFile,  'hydra/works/services/generic_file/remove_related_object'
    autoload :UploadFileToGenericFile,             'hydra/works/services/generic_file/upload_file'
    autoload :GenerateThumbnail,                   'hydra/works/services/generic_file/generate/thumbnail'
    autoload :PersistDerivative,                   'hydra/works/services/generic_file/persist_derivative'

    # model validations - these have been deprecated
    def self.collection? collection
      warn "[DEPRECATION] `collection? collection` is deprecated.  Please use `works_collection?` instead.  This has a target date for removal of 07-31-2015"
      collection.works_collection?
    end

    def self.generic_work? generic_work
      warn "[DEPRECATION] `generic_work? generic_work` is deprecated.  Please use `works_generic_work?` instead.  This has a target date for removal of 07-31-2015"
      generic_work.works_generic_work?
    end

    def self.generic_file? generic_file
      warn "[DEPRECATION] `generic_file? generic_file` is deprecated.  Please use `works_generic_file?` instead.  This has a target date for removal of 07-31-2015"
      generic_file.works_generic_file?
    end

  end
end
