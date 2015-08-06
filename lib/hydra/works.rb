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
    autoload :GenericFile,            'hydra/works/models/generic_file'
    autoload :BlockChildObjects,      'hydra/works/models/concerns/block_child_objects'

    # generic_file services
    autoload :AddFileToGenericFile,    'hydra/works/services/generic_file/add_file_to_generic_file'
    autoload :GenerateThumbnail,       'hydra/works/services/generic_file/generate/thumbnail'
    autoload :UploadFileToGenericFile, 'hydra/works/services/generic_file/upload_file'
    autoload :PersistDerivative,       'hydra/works/services/generic_file/persist_derivative'
  end
end
