# The base class of all works
module Hydra::Works
  class Work < ActiveFedora::Base
    include Hydra::Works::CurationConcern::Work
  end
end
