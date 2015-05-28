module Hydra::Works
  # Namespace for Modules with functionality specific to GenericWorks
  module GenericWork
    # Base class for creating objects that behave like Hydra::Works::GenericWorks
    class Base < ActiveFedora::Base
      include Hydra::Works::GenericWorkBehavior
    end
  end
end
