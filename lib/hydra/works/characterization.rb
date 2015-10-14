module Hydra::Works
  module Characterization
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :FitsDatastream, 'hydra/works/models/characterization/fits_datastream.rb'
    autoload :AlreadyThereStrategy, 'hydra/works/models/characterization/already_there_strategy.rb'

    autoload_under 'schema' do
      autoload :AudioSchema
      autoload :BaseSchema
      autoload :DocumentSchema
      autoload :ImageSchema
      autoload :VideoSchema
    end

    autoload :Base, 'hydra/works/models/concerns/file_set/characterization/base.rb'
    autoload :Image, 'hydra/works/models/concerns/file_set/characterization/image.rb'
    autoload :Document, 'hydra/works/models/concerns/file_set/characterization/document.rb'
    autoload :Video, 'hydra/works/models/concerns/file_set/characterization/video.rb'
    autoload :Audio, 'hydra/works/models/concerns/file_set/characterization/audio.rb'

    included do
      include Base
      include Image
      include Audio
      include Video
      include Document
    end
  end
end
