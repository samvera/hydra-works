module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works generic works
  module AggregatesGenericWorks

    def generic_works= generic_works
      raise ArgumentError, "each generic_work must be a hydra works generic work" unless generic_works.all? { |w| Hydra::Works.generic_work? w }
      raise ArgumentError, "a generic work can't be an ancestor of itself" if self.respond_to?(:object_ancestor?) && object_ancestor?(generic_works)
      if self.respond_to?(:generic_files)
        self.members = self.generic_files + generic_works
      else
        self.members = generic_works
      end
    end

    def generic_works
      members.to_a.select { |m| Hydra::Works.generic_work? m }
    end

  end
end
