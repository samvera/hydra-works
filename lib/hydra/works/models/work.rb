module Hydra::Works
  # Namespace for Modules with functionality specific to Works
  class Work < ActiveFedora::Base
    include Hydra::Works::WorkBehavior
  end
end
