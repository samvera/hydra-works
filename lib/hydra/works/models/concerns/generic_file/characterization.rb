module Hydra::Works::GenericFile
  module Characterization
    extend ActiveSupport::Concern

    autoload :Base, 'hydra/works/models/concerns/generic_file/characterization/base.rb'
    autoload :Image, 'hydra/works/models/concerns/generic_file/characterization/image.rb'
    autoload :Document, 'hydra/works/models/concerns/generic_file/characterization/document.rb'
    autoload :Video, 'hydra/works/models/concerns/generic_file/characterization/video.rb'
    autoload :Audio, 'hydra/works/models/concerns/generic_file/characterization/audio.rb'

    included do
      include Characterization::Base
      include Characterization::Image
      include Characterization::Audio
      include Characterization::Video
      include Characterization::Document
    end
  end
end
