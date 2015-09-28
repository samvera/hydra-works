require 'hydra/works/version'
require 'active_fedora/aggregation'
require 'hydra/pcdm'
require 'hydra/derivatives'

module Hydra
  module Works
    extend ActiveSupport::Autoload

    module Vocab
      extend ActiveSupport::Autoload
      eager_autoload do
        autoload :WorksTerms
      end
    end

    autoload_under 'models' do
      autoload :Collection
      autoload :GenericWork
      autoload :GenericFile
    end

    autoload_under 'models/concerns' do
      autoload :CollectionBehavior
      autoload :GenericWorkBehavior
      autoload :GenericFileBehavior
      autoload :BlockChildObjects
    end

    autoload_under 'services/generic_file' do
      autoload :AddFileToGenericFile
      autoload :UploadFileToGenericFile
      autoload :PersistDerivative
      autoload :FullTextExtractionService
    end

    autoload_under 'errors' do
      autoload :FullTextExtractionError
    end
  end
end
