module Hydra::Works
  class GetGenericWorksFromGenericWork

    ##
    # Get member generic works from a generic work in order.
    #
    # @param [Hydra::Works::GenericWork::Base] :parent_generic_work in which the child generic works are members
    #
    # @return [Array<Hydra::Works::GenericWork::Base>] all member generic works

    def self.call( parent_generic_work )
      raise ArgumentError, 'parent_generic_work must be a hydra-works generic work' unless Hydra::Works.generic_work? parent_generic_work
      parent_generic_work.generic_works
    end

  end
end
