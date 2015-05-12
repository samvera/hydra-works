module Hydra::Works
  class GenericFile < ActiveFedora::Base
    include Hydra::Works::GenericFileBehavior
  end
end
