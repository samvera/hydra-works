module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works generic files
  module AggregatesGenericFiles

    def generic_file_ids
      generic_files.map(&:id)
    end
  end

end
