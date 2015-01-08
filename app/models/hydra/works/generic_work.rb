# a very simple type of work with DC metadata
module Hydra::Works
  class GenericWork < Work
    include Hydra::Works::CurationConcern::WithBasicMetadata
  end
end
