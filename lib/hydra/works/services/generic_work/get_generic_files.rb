module Hydra::Works
  class GetGenericFilesFromGenericWork

    ##
    # Get member generic files from a generic work in order.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work in which the child generic files are members
    #
    # @return [Array<Hydra::Works::GenericFile::Base>] all member generic files

    def self.call( parent_generic_work )
      warn "[DEPRECATION] `Hydra::PCDM::GetGenericFilesFromGenericWork` is deprecated.  Please use syntax `generic_files = parent_generic_work.generic_files` instead.  NOTE: The new syntax returns an association instead of an array.  This has a target date for removal of 07-31-2015"
      parent_generic_work.generic_files.to_a
    end

  end
end
