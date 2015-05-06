require 'hydra/works/version'
require 'active_fedora/aggregation'
require 'hydra/pcdm'

module Hydra
  module Works

    # models
    autoload :Collection,             'hydra/works/models/collection'
    autoload :GenericWork,            'hydra/works/models/generic_work'
    autoload :GenericFile,            'hydra/works/models/generic_file'
    
    #behaviors
    autoload :CollectionBehavior,     'hydra/works/models/concerns/collection_behavior'
    autoload :WorkBehavior,           'hydra/works/models/concerns/work_behavior'
    autoload :FileBehavior,           'hydra/works/models/concerns/file_behavior'
  
  end
end
