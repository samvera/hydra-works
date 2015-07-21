module Hydra::Works
  class GetGenericFilesFromGenericFile

    ##
    # Get member generic files from a generic file in order.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file in which the child generic files are members
    #
    # @return [Array<Hydra::Works::GenericFile::Base>] all member generic files

    def self.call( parent_generic_file )
      warn "[DEPRECATION] `Hydra::PCDM::GetGenericFilesFromGenericFile` is deprecated.  Please use syntax `child_generic_files = parent_generic_file.child_generic_files` instead.  NOTE: The new syntax returns an association instead of an array.  This has a target date for removal of 07-31-2015"
      parent_generic_file.child_generic_files.to_a
    end

  end
end
