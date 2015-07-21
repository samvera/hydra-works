module Hydra::Works
  class RemoveGenericWorkFromCollection

    ##
    # Remove a generic_work from a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection from which to remove generic_work
    # @param [Hydra::Works::GenericWork::Base] :child_generic_work being removed
    # @param [Fixnum] :nth_occurrence remove nth occurrence of this generic_work in the list (default=1)
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_generic_work, nth_occurrence=1 )
      warn "[DEPRECATION] `Hydra::Works::RemoveGenericWorkFromCollection` is deprecated.  Please use syntax `parent_collection.child_generic_works.delete child_generic_work` instead which returns [child_generic_work] instead of child_generic_work.  This has a target date for removal of 07-31-2015"
      result = parent_collection.child_generic_works.delete child_generic_work
      result = result.first if result.kind_of?(Array) && result.size >= 1      # temporarily done for compatibility with current service object API
      result

      # TODO FIX when members is empty, members.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #35)

      # TODO -- The same object may be in the list multiple times.  (issue pcdm-102 & AF-Agg-46)
      #   * How to remove nth occurrence?
      #   * Default to removing 1st occurrence from the beginning of the list.
    end
  end
end
