module Hydra::Works
  class AddGenericFileToGenericWork

    ##
    # Add a generic_file to a generic_work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work to which to add generic_work
    # @param [Hydra::Works::GenericFile::Base] :child_generic_file being added
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_generic_file )
      warn "[DEPRECATION] `Hydra::Works::AddGenericFileToGenericWork` is deprecated.  Please use syntax `parent_generic_work.child_generic_files << child_generic_file` instead.  This has a target date for removal of 07-31-2015"
      parent_generic_work.child_generic_files << child_generic_file
    end
  end
end
