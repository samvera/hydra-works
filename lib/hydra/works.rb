require "hydra/head"
require "hydra-collections"
require "hydra/works/version"
require "hydra/works/engine"
module Hydra
  module Works
  end
end

module ActiveFedora
  module RDF # TODO move these into ActiveFedora?
    ProjectHydra.property :hasMember, label: 'Has Member'.freeze,
      subPropertyOf: 'http://www.openarchives.org/ore/terms/aggregates'.freeze,
      type: 'rdf:Property'.freeze

    ProjectHydra.property :contains, label: 'Contains'.freeze,
      subPropertyOf: 'http://projecthydra.org/ns/relations#hasMember'.freeze,
      type: 'rdf:Property'.freeze

    ProjectHydra.property :hasFile, label: 'Has File'.freeze,
      subPropertyOf: 'http://projecthydra.org/ns/relations#contains'.freeze,
      type: 'rdf:Property'.freeze
  end
end
