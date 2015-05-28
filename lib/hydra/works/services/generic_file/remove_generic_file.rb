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
      raise ArgumentError, 'parent_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? parent_generic_file
      raise ArgumentError, 'child_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? child_generic_file
      Hydra::PCDM::RemoveObjectFromObject.call( parent_generic_file, child_generic_file, nth_occurrence )
    end

  end
end
