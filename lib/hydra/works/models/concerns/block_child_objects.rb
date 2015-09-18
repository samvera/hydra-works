module Hydra::Works
  # Do not allow aggregation of child objects
  module BlockChildObjects
    def objects=(_objects)
      fail StandardError, "method `objects=' not allowed for #{self}"
    end

    def objects
      fail StandardError, "method `objects' not allowed for #{self}"
    end

    def child_objects=(new_objects)
      warn '[DEPRECATION] `child_objects=` is deprecated in Hydra::Works.  Please use `objects=` instead.  This has a target date for removal of 10-31-2015'
      self.objects = new_objects
    end

    def child_objects
      warn '[DEPRECATION] `child_objects` is deprecated in Hydra::Works.  Please use `objects` instead.  This has a target date for removal of 10-31-2015'
      objects
    end
  end
end
