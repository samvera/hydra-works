module Hydra
  module Works
    # The necessary attributes to implement a compliant
    # Hydra::Works::GenericWork object.
    module GenericWork
      # hydra:hasMember predicate
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      HAS_MEMBER_PROPERTY_NAME = 'hydra:hasMember'.freeze

      # hydra:hasFile predicate
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      HAS_FILE_PROPERTY_NAME = 'hydra:hasFile'.freeze

      # @returns [Array<Hydra::Works::GenericWork>]
      def member_works
        fail NotImplementedError
      end

      # @returns [Array<Hydra::Works::GenericFile>]
      def files
        fail NotImplementedError
      end
    end
  end
end
