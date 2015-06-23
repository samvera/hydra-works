module Hydra::Works
  class GenerateThumbnail

    def self.call(object, content: :original_file)
      raise ArgumentError, "object has no content at #{content} from which to generate a thumbnail" if object.send(content).nil?
      source = object.send(content)

      # Always replace the thumbnail with whatever is from the original file
      if object.thumbnail.nil?
        object.build_thumbnail
      end
      
      object.create_derivatives
      object
    end

  end
end
