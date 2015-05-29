module Hydra::Works
  class GetGenericFilesFromGenericFile

    ##
    # Get member generic files from a generic file in order.
    #
    # @param [Hydra::Works::GenericFile::Base] :parent_generic_file in which the child generic files are members
    #
    # @return [Array<Hydra::Works::GenericFile::Base>] all member generic files

    def self.call( parent_generic_file )
      raise ArgumentError, 'parent_generic_file must be a hydra-works generic file' unless Hydra::Works.generic_file? parent_generic_file
      parent_generic_file.generic_files
    end

  end
end
