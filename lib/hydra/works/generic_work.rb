module Hydra
  module Works
    # The
    module GenericWork
      HAS_MEMBER_PROPERTY_NAME = 'hydra:hasMember'.freeze
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
