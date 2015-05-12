module Hydra::Works
  class GenericFile < ActiveFedora::Base
    include Hydra::Works::FileBehavior
    include Hydra::Works::ContainedFiles
  end
end
