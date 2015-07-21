module Hydra::Works
  class GetGenericWorksFromCollection

    ##
    # Get member generic works from a collection in order.
    #
    # @param [Hydra::Works::Collection] :parent_collection in which the child generic works are members
    #
    # @return [Array<Hydra::Works::GenericWork::Base>] all member generic works

    def self.call( parent_collection )
      warn "[DEPRECATION] `Hydra::PCDM::GetGenericWorksFromCollection` is deprecated.  Please use syntax `child_generic_works = parent_collection.child_generic_works` instead.  NOTE: The new syntax returns an association instead of an array.  This has a target date for removal of 07-31-2015"
      parent_collection.child_generic_works.to_a
    end

  end
end
