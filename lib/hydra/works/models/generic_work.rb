module Hydra::Works
  # Typically used for very generic applications that don't differntiate
  # between specific content types. If you want a specific type of work
  # extend Active::Fedora base and include the following:
  #  include Hydra::Works::WorkBehavior
  class GenericWork < ActiveFedora::Base
    include Hydra::Works::WorkBehavior

    # @deprecated Base class for creating objects that behave like Hydra::Works::GenericWorks
    class Base < ActiveFedora::Base
      extend Deprecation
      after_initialize :deprecated_warning
      include Hydra::Works::WorkBehavior

      def deprecated_warning
        Deprecation.warn(Base, "GenericWork is deprecated and will be removed in Hydra::Works 0.4.0. Use Hydra::Works::GenericWork instead")
      end
    end
  end
end
