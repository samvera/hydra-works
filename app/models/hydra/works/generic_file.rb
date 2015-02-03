module Hydra::Works
  class GenericFile < ActiveFedora::Base
    # TODO this could actually be "has_one", but that's not implemented
    has_many :works, predicate: ActiveFedora::RDF::ProjectHydra.hasFile, class_name: "Hydra::Works::Work"

    def work
      works.first
    end

    def work=(work)
      self.works = [work]
    end

    def work_id
      work.id
    end

    def work_id=(work_id)
      self.work_ids = [work_id]
    end
  end
end
