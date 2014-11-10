module Hydra
  module Works
    # A container module for all of the property definitions used by
    # Hydra::Works.
    module Properties
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      AGGREGATES = 'ore:aggregates'.freeze

      # hydra:hasMember predicate
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      HAS_MEMBER = 'hydra:hasMember'.freeze

      # hydra:hasFile predicate
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      HAS_FILE = 'hydra:hasFile'.freeze
    end
  end
end
