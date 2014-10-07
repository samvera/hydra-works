module Hydra::Works
  class Work < ActiveFedora::Base
    include Hydra::Works::CurationConcern::Work
    include Hydra::Works::CurationConcern::WithBasicMetadata
  end
end
