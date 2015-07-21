module Hydra::Works
  class AddGenericWorkToGenericWork

    ##
    # Add a generic_work to a generic_work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work to which to add generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being added
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_generic_work )
      warn "[DEPRECATION] `Hydra::Works::AddGenericWorkToGenericWork` is deprecated.  Please use syntax `parent_generic_work.child_generic_works << child_generic_work` instead.  This has a target date for removal of 07-31-2015"
      parent_generic_work.child_generic_works << child_generic_work
    end
  end
end
