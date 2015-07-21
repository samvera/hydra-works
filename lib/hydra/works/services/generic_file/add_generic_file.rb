module Hydra::Works
  class AddGenericFileToGenericFile

    ##
    # Add a generic_file to a generic_file.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file to which to add generic_file
    # @param [Hydra::Works::GenericFile::Base] :child_generic_file being added
    #
    # @return [Hydra::Works::GenericFile::Base] the updated hydra works generic file

    def self.call( parent_generic_file, child_generic_file )
      warn "[DEPRECATION] `Hydra::Works::AddGenericFileToGenericFile` is deprecated.  Please use syntax `parent_generic_file.child_generic_files << child_generic_file` instead.  This has a target date for removal of 07-31-2015"
      parent_generic_file.child_generic_files << child_generic_file
    end
  end
end
