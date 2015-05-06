module Hydra::Works
  class GenericWork < ActiveFedora::Base
    include Hydra::Works::WorkBehavior
  end
end
