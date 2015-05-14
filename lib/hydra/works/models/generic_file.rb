module Hydra::Works
  class GenericFile < ActiveFedora::Base
    include Hydra::Works::GenericFileBehavior
    include Hydra::Works::ContainedFiles
  end
end
