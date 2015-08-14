module Hydra::Works
  # Do not allow aggregation of child objects
  module BlockChildObjects
    def child_objects=(_objects)
      fail StandardError, "method `child_objects=' not allowed for #{self}"
    end

    def child_objects
      fail StandardError, "method `child_objects' not allowed for #{self}"
    end
  end
end
