module Hydra::Works
  class GenericFile < ActiveFedora::Base
    include Hydra::Works::GenericFileBehavior
    include Hydra::Works::ContainedFiles
    include Hydra::Works::Derivatives
    include Hydra::Works::MimeTypes
  end
end
