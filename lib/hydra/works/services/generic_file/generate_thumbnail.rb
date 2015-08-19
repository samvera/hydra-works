module Hydra::Works
  class GenerateThumbnail
    def self.call(object, content: :original_file)
      fail ArgumentError, "object has no content at #{content} from which to generate a thumbnail" if object.send(content).nil?

      # Always replace the thumbnail with whatever is from the original file
      object.build_thumbnail if object.thumbnail.nil?

      object.create_derivatives
      object
    end
  end
end
