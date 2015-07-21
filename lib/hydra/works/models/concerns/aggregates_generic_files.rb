module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works generic files
  module AggregatesGenericFiles

    def child_generic_file_ids
      child_generic_files.map(&:id)
    end

    def generic_files= generic_files
      warn "[DEPRECATION] `generic_files=` is deprecated.  Please use `child_generic_files=` instead.  This has a target date for removal of 07-31-2015"
      self.child_generic_files = generic_files
    end

    def generic_files
      warn "[DEPRECATION] `generic_files` is deprecated.  Please use `child_generic_files` instead.  This has a target date for removal of 07-31-2015"
      self.child_generic_files
    end
  end

end
