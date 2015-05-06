module Hydra::Works
  class GenericFile < ActiveFedora::Base
    include Hydra::Works::FileBehavior
  end
end
