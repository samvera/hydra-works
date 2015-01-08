module Hydra::Works
  class GenericFile < ActiveFedora::Base
    belongs_to :work, predicate: ActiveFedora::RDF::RelsExt.isPartOf, class_name: "Hydra::Works::Work"
  end
end
