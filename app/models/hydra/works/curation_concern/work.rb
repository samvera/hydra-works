module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include WithGenericFiles
    end
  end
end
