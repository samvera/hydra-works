module Hydra
  module Works
    # A container module for all of the property definitions used by
    # Hydra::Works.
    #
    # @see https://docs.google.com/document/d/1o-Iq1oKN_W5NXXDQC81pxkhibOz_AhZlY7IShxPTR5M/edit#
    module Properties
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      AGGREGATES = 'ore:aggregates'.freeze

      # hydra:hasMember predicate, is a sub-type of 'ore:aggregates'
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      # @see Hydra::Works::Properties::AGGREGATES
      HAS_MEMBER = 'hydra:hasMember'.freeze

      # hydra:hasFile predicate, is a sub-type of 'hydra:contains'
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      HAS_FILE = 'hydra:hasFile'.freeze

      # hydra:contains predicate, is a sub-type of 'hydra:hasMember'
      #
      # @api private
      # @since 0.0.1.pre
      #
      # @see Hydra::Works application profile
      CONTAINS = 'hydra:contains'.freeze
    end
  end
end
