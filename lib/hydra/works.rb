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

    autoload_under 'models/concerns/file_set' do
      autoload :Derivatives
      autoload :MimeTypes
      autoload :ContainedFiles
      autoload :VersionedContent
      autoload :VirusCheck
    end

    autoload :Characterization

    autoload_under 'models' do
      autoload :Collection
      autoload :FileSet
      autoload :Work
    end

    autoload_under 'models/concerns' do
      autoload :CollectionBehavior
      autoload :FileSetBehavior
      autoload :WorkBehavior
    end

    autoload_under 'services' do
      autoload :AddFileToFileSet
      autoload :UploadFileToFileSet
      autoload :PersistDerivative
      autoload :CharacterizationService
    end
  end
end
