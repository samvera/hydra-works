module Hydra::Works
  class GetGenericWorksFromCollection

    ##
    # Get member generic works from a collection in order.
    #
    # @param [Hydra::Works::Collection] :parent_collection in which the child generic works are members
    #
    # @return [Array<Hydra::Works::GenericWork::Base>] all member generic works

    def self.call( parent_collection )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      parent_collection.generic_works
    end

  end
end
