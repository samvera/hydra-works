module Hydra::Works
  class AddGenericFileToGenericFile

    ##
    # Add a generic_file to a generic_file.
    #
    # @param [Hydra::Works::GenericFile] :parent_generic_file to which to add generic_file
    # @param [Hydra::Works::GenericFile] :child_generic_file being added
    #
    # @return [Hydra::Works::GenericFile] the updated hydra works generic file

    def self.call( parent_generic_file, child_generic_file )
      raise ArgumentError, 'parent_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? parent_generic_file
      raise ArgumentError, 'child_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? child_generic_file
      Hydra::PCDM::AddObjectToObject.call( parent_generic_file, child_generic_file )
    end

  end
end
