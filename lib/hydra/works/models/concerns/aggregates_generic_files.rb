module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works generic files
  module AggregatesGenericFiles

    def generic_files= generic_files
      raise ArgumentError, "each generic_file must be a hydra works generic file" unless generic_files.all? { |w| Hydra::Works.generic_file? w }
      raise ArgumentError, "a generic file can't be an ancestor of itself" if object_ancestor?(generic_files)
      if self.respond_to?(:generic_works)
        self.members = self.generic_works + generic_files
      else
        self.members = generic_files
      end
    end

    def generic_files
      members.to_a.select { |m| Hydra::Works.generic_file? m }
    end
  end

end
