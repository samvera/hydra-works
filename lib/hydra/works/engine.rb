# require 'hydra-collections'
require 'rails'

require 'action_view' # for HAML deep in ActiveFedora/RDFA

module Hydra::Works
  class Engine < ::Rails::Engine
    isolate_namespace Hydra::Works
  end
end

