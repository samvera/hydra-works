module Hydra::Works
  # Typically used for very generic applications that don't differntiate
  # between specific content types. If you want a specific type of work
  # extend Active::Fedora base and include the following:
  #  include Hydra::Works::WorkBehavior
  class GenericWork < ActiveFedora::Base
    include Hydra::Works::WorkBehavior
  end
end
