module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include Curatable
      include WithGenericFiles
      include Hydra::AccessControls::Embargoable

      def to_solr(solr_doc={})
        super.tap do |solr_doc|
          Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
        end
      end
    end
  end
end
