module Hydra::Works
  class RemoveRelatedObjectFromCollection

    ##
    # Remove a related object from a collection.
    #
    # @param [Hydra::Works::Collection] :parent_collection from which to remove the related object
    # @param [Hydra::PCDM::Object] :child_related_object being removed
    #
    # @return [Hydra::Works::Collection] the updated hydra works collection

    def self.call( parent_collection, child_related_object )
      raise ArgumentError, 'parent_collection must be a hydra-works collection' unless Hydra::Works.collection? parent_collection
      raise ArgumentError, 'child_related_object must be a pcdm object' unless Hydra::PCDM.object? child_related_object
      Hydra::PCDM::RemoveRelatedObjectFromCollection.call( parent_collection, child_related_object )
    end

  end
end
