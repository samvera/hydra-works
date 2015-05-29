module Hydra::Works
  class GetGenericFilesFromGenericWork

    ##
    # Get member generic files from a generic work in order.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work in which the child generic files are members
    #
    # @return [Array<Hydra::Works::GenericFile::Base>] all member generic files

    def self.call( parent_generic_work )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      parent_generic_work.generic_files
    end

  end
end
