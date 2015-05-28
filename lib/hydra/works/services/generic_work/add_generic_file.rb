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
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      raise ArgumentError, 'child_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? child_generic_file
      Hydra::PCDM::AddObjectToObject.call( parent_generic_work, child_generic_file )
    end

  end
end
