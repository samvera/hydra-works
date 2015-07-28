module Hydra::Works
  class CollectionIndexer < Hydra::PCDM::CollectionIndexer
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc["child_generic_work_ids_ssim"] = object.child_generic_work_ids
      end
    end
  end
end
