module Hydra::Works
  class AddGenericWorkToCollection

    ##
    # Add a generic_work to a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection to which to add generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being added
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_generic_work )
      warn "[DEPRECATION] `Hydra::Works::AddGenericWorkToCollection` is deprecated.  Please use syntax `parent_collection.child_generic_works << child_generic_work` instead.  This has a target date for removal of 07-31-2015"
      parent_collection.child_generic_works << child_generic_work
    end

  end
end
