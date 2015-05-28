module Hydra::Works
  class GetRelatedObjectsFromGenericFile

    ##
    # Get related objects from a generic_file.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file to which the child objects are related
    #
    # @return [Array<Hydra::Works::GenericFile::Base>] all related objects

    def self.call( parent_generic_file )
      raise ArgumentError, 'parent_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? parent_generic_file
      Hydra::PCDM::GetRelatedObjectsFromObject.call( parent_generic_file )
    end

  end
end
