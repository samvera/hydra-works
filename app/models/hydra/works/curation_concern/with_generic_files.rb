module Hydra::Works
  module CurationConcern
    module WithGenericFiles
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :files, predicate: ActiveFedora::RDF::ProjectHydra.hasFile, class_name: "Hydra::Works::GenericFile"
      end

    end
  end
end
