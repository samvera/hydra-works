module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include Curatable
      include WithGenericFiles
      include Hydra::AccessControls::Embargoable

      def to_solr(solr_doc={}, opts={})
        super(solr_doc, opts)
        Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
        return solr_doc
      end
    end
  end
end
