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
      autoload :Characterization
    end

    autoload_under 'models' do
      autoload :Collection
      autoload :FileSet
      autoload :GenericWork
      autoload :GenericFile # Deprecated. Remove in 0.4.0
    end

    autoload_under 'models/concerns' do
      autoload :CollectionBehavior
      autoload :FileSetBehavior
      autoload :GenericWorkBehavior # Deprecated. Remove in 0.4.0
      autoload :GenericFileBehavior # Deprecated. Remove in 0.4.0
      autoload :WorkBehavior
    end

    autoload_under 'services' do
      autoload :AddFileToFileSet
      autoload :AddFileToGenericFile # Deprecated. Remove in 0.4.0
      autoload :UploadFileToFileSet
      autoload :UploadFileToGenericFile # Deprecated. Remove in 0.4.0
      autoload :PersistDerivative
      autoload :CharacterizationService
    end
  end
end
