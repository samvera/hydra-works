module Hydra
  module Works
    # The necessary attributes to implement a compliant
    # Hydra::Works::GenericAdministrativeSet object.
    module GenericAdministrativeSet
      # @returns [Array<Hydra::GenericWork, Hydra::GenericCollection>]
      # @see Hydra::Works::Properties::CONTAINS
      def contains
        fail NotImplementedError
      end
    end
  end
end
