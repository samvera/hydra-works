module Hydra::Works
  class GenerateExtractedText
    def self.call(object, content: :original_file)
      fail ArgumentError, "object has no content at #{content} from which to generate extracted text" if object.send(content).nil?

      # Always replace the thumbnail with whatever is from the original file
      object.build_extracted_text if object.build_extracted_text.nil?
      object.extracted_text.content = Hydra::Works::FullTextExtractionService.run(object)
      object.save
      object
    end
  end
end
