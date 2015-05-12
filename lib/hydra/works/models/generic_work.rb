module Hydra::Works
  class GenericWork < ActiveFedora::Base
    include Hydra::Works::GenericWorkBehavior
  end
end
