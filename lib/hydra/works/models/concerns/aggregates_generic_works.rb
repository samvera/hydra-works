module Hydra::Works
  # Allows instances of a class to aggregate (pcdm:hasMember) hydra-works generic works
  module AggregatesGenericWorks

    def child_generic_work_ids
      child_generic_works.map(&:id)
    end

    def generic_works= generic_works
      warn "[DEPRECATION] `generic_works=` is deprecated.  Please use `child_generic_works=` instead.  This has a target date for removal of 07-31-2015"
      self.child_generic_works = generic_works
    end

    def generic_works
      warn "[DEPRECATION] `generic_works` is deprecated.  Please use `child_generic_works` instead.  This has a target date for removal of 07-31-2015"
      self.child_generic_works
    end

  end
end
