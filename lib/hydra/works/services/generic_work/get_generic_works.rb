module Hydra::Works
  class GetGenericWorksFromGenericWork

    ##
    # Get member generic works from a generic work in order.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work in which the child generic works are members
    #
    # @return [Array<Hydra::Works::GenericWork::Base>] all member generic works

    def self.call( parent_generic_work )
      warn "[DEPRECATION] `Hydra::PCDM::GetGenericWorksFromGenericWork` is deprecated.  Please use syntax `child_generic_works = parent_generic_work.child_generic_works` instead.  NOTE: The new syntax returns an association instead of an array.  This has a target date for removal of 07-31-2015"
      parent_generic_work.child_generic_works.to_a
    end

  end
end
