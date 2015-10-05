module Hydra::Works
  # Namespace for Modules with functionality specific to GenericFiles
  module GenericFile
    extend ActiveSupport::Concern

    # @deprecated Base class for creating objects that behave like Hydra::Works::GenericFiles
    class Base < ActiveFedora::Base
      extend Deprecation
      include Hydra::Works::FileSetBehavior
      after_initialize :deprecation_warning

      def deprecation_warning
        Deprecation.warn Base, "Hydra::Works::FileSet is deprecated and will be removed in 0.4.0. Use Hydra::Works::FileSet instead"
      end
    end
  end
end
