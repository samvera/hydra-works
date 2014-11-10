module Hydra
  module Works
    # The necessary attributes to implement a compliant
    # Hydra::Works::GenericCollection object.
    module GenericCollection
      # @returns [Array<rdf:Resource>]
      # @see Hydra::Works::Properties::AGGREGATES
      def aggregates
        fail NotImplementedError
      end
    end
  end
end
