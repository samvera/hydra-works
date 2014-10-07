module Hydra::Works
  module CurationConcern
    module Work
      extend ActiveSupport::Concern
      include Curatable
      include WithGenericFiles
      include Hydra::AccessControls::Embargoable
      include WithEditors
      include WithLinkedResources

      included do
        has_metadata "properties", type: Hydra::Works::PropertiesDatastream
        has_attributes :depositor, :representative, datastream: :properties, multiple: false
      end

      def to_solr(solr_doc={}, opts={})
        super(solr_doc, opts)
        Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)
        return solr_doc
      end
    end
  end
end
