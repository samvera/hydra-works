module Hydra::Works
  # Do not allow aggregation of child objects
  module BlockChildObjects

    def child_objects= objects
      raise StandardError, "method `child_objects=' not allowed for #{self}"
    end

    def child_objects
      raise StandardError, "method `child_objects' not allowed for #{self}"
    end

  end
end


