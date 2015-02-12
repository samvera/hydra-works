module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include WithFiles
      include DestroyFilesToo
    end
  end
end
