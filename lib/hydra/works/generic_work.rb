module Hydra
  module Works
    # The necessary attributes to implement a compliant
    # Hydra::Works::GenericWork object.
    module GenericWork
      # @returns [Array<Hydra::Works::GenericWork>]
      #
      # @see Hydra::Works::Properties::HAS_MEMBER
      def member_works
        fail NotImplementedError
      end

      # @returns [Array<Hydra::Works::GenericFile>]
      #
      # @see Hydra::Works::Properties::HAS_FILE
      def files
        fail NotImplementedError
      end
    end
  end
end
