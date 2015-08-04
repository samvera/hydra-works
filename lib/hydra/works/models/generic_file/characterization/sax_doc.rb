module Hydra::Works::GenericFile
  # Run FITS to gather technical metadata about the content.
  # Store extracted metadata as properties on the file.
  module Characterization
    # SAX parsing class for FITS
    # Requires fits_to_rdf_mapping
    class SaxDoc < Nokogiri::XML::SAX::Document
      attr_reader :property_values

      # Stateful tracking of parsing an element of interest
      # Value is either nil or keys of the config
      @interested = nil

      # The property to be checked for the assigned values
      def initialize(cfg)
        @elems = Hash.new { |k, v| k[v] = [] }
        @attr_conds = {}
        @attr_targs = {}
        @property_values = {}
        initialize_config(cfg)
      end

      # Reverse of config hash of "fits xml element name" => [:property_name1, :property_name2]
      # Config hash of property => "attribute_name=value".
      # Config hash of property => "attribute_name".
      def initialize_config(cfg)
        cfg.each do |p, v|
          if v.is_a? Array
            # First value is the element name
            @elems[v.first] << p
            # Split remaining strings, if present, into conditions and targets
            @attr_conds[p], @attr_targs[p] = v[1..v.size].partition { |s| s.include? "=" }
          else
            @elems[v] << p
          end
        end
      end

      def property_values
        @property_values.compact
      end

      def start_element(name, attrs = [])
        # Short circut unless name a key in the elements hash
        return unless @elems.key? name

        # Get array of property symbols for given element name
        # each is used as a key in the other hashes
        # Reduce list of poperties for the named element to those that also match by attribute.
        props = @elems[name].select { |p| match_attrs?(p, attrs) }

        # If the properties have target attributes, append those values
        props.each { |p| append_values(p, target_values(p, attrs)) }

        # Update state to have content captured as well
        @interested = props
      end

      def end_element(_name)
        # Unset interested at end of each element
        @interested = nil if @interested
      end

      def characters(string)
        return unless @interested
        # Skip if string is only whitespace.
        return if string =~ /^\s*$/

        @interested.each { |p| append_values(p, string) }
      end

      # Get the values of the target attributes if present.
      def target_values(prop, attrs)
        # Bail early if there are no attribute targets
        return nil unless @attr_targs[prop]
        # get the values of the target attributes
        @attr_targs[prop].map do |t|
          val = attrs.assoc(t)
          val[1] if val
        end
      end

      # Match conditional attributes of config against attrs of element
      def match_attrs?(prop, attrs)
        # bail early if there aren't condition attributes for the property.
        return true unless @attr_conds.key?(prop)

        # The attrs are [name, value].  Split conditions to match.  all conditions need to be matched.
        @attr_conds[prop].all? do |cond|
          attrs.include? cond.split("=")
        end
      end

      def append_values(property, value)
        return if property.nil? || value.nil?
        value = rectify_value(value)
        if @property_values.key?(property)
          @property_values[property].push(*value)
        else
          @property_values[property] = value
        end
      end

      def rectify_value(val)
        val.is_a?(Array) ? val.compact : [val]
      end
    end # SaxDoc class
  end
end
