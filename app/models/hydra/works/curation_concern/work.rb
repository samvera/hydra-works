module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include WithGenericFiles
      include DestroyGenericFilesToo
    end
  end
end
