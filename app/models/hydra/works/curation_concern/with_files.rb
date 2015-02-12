module Hydra::Works
  module CurationConcern
    module WithFiles
      extend ActiveSupport::Concern

      included do
        has_and_belongs_to_many :files, predicate: ActiveFedora::RDF::ProjectHydra.hasFile, class_name: "Hydra::Works::File"
        before_destroy :before_destroy_cleanup_generic_files
      end

      def before_destroy_cleanup_generic_files
        files.each(&:destroy)
      end
    end
  end
end
