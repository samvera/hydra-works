module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include WithFiles
    end
  end
end
