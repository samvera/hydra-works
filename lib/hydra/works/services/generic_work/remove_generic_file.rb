module Hydra::Works
  class RemoveGenericFileFromGenericWork

    ##
    # Remove a generic_file from a generic_work.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work from which to remove generic_work
    # @param [Hydra::Works::GenericFile::Base] :child_generic_file being removed
    # @param [Fixnum] :nth_occurrence remove nth occurrence of this generic_work in the list (default=1)
    #
    # @return [Hydra::Works::GenericWork::Base] the updated hydra works generic work

    def self.call( parent_generic_work, child_generic_file, nth_occurrence=1 )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      raise ArgumentError, 'child_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? child_generic_file
      Hydra::PCDM::RemoveObjectFromObject.call( parent_generic_work, child_generic_file, nth_occurrence )
    end

  end
end
