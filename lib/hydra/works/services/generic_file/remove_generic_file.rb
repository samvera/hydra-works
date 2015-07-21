module Hydra::Works
  class RemoveGenericFileFromGenericFile

    ##
    # Remove a generic_file from a generic_file.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file from which to remove generic_file
    # @param [Hydra::Works::GenericFile::Base] :child_generic_file being removed
    # @param [Fixnum] :nth_occurrence remove nth occurrence of this generic_file in the list (default=1)
    #
    # @return [Hydra::Works::GenericFile::Base] the updated hydra works generic file

    def self.call( parent_generic_file, child_generic_file, nth_occurrence=1 )
      warn "[DEPRECATION] `Hydra::Works::RemoveGenericFileFromGenericFile` is deprecated.  Please use syntax `parent_generic_file.child_generic_files.delete child_generic_file` instead which returns [child_generic_file] instead of child_generic_file.  This has a target date for removal of 07-31-2015"
      result = parent_generic_file.child_generic_files.delete child_generic_file
      result = result.first if result.kind_of?(Array) && result.size >= 1      # temporarily done for compatibility with current service object API
      result

      # TODO FIX when members is empty, members.delete raises ActiveFedora::ObjectNotFoundError "Can't reload an object that hasn't been saved"  (activefedora-aggregation issue #35)

      # TODO -- The same object may be in the list multiple times.  (issue pcdm-102 & AF-Agg-46)
      #   * How to remove nth occurrence?
      #   * Default to removing 1st occurrence from the beginning of the list.
    end
  end
end
