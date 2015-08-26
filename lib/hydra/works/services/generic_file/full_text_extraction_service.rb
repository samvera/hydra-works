module Hydra::Works
  # Extract the full text from the content using Solr's extract handler
  class FullTextExtractionService
    def self.run(generic_file)
      new(generic_file).extract
    end

    delegate :original_file, :id, to: :@generic_file

    def initialize(generic_file)
      @generic_file = generic_file
    end

    ##
    # Extract full text from the content using Solr's extract handler.
    # This will extract text from the file uploaded to generic_file.
    # The file uploaded to @generic_file can be accessed via :original_file.
    #
    # @return [String] The extracted text
    def extract
      uri = URI("#{connection_url}/update/extract?extractOnly=true&wt=json&extractFormat=text")
      req = Net::HTTP.new(uri.host, uri.port)
      resp = req.post(uri.to_s, original_file.content, 'Content-type' => "#{original_file.mime_type};charset=utf-8", 'Content-Length' => original_file.content.size.to_s)
      fail "URL '#{uri}' returned code #{resp.code}" unless resp.code == '200'
      original_file.content.rewind if original_file.content.respond_to?(:rewind)
      JSON.parse(resp.body)[''].rstrip

    rescue => e
      raise Hydra::Works::FullTextExtractionError.new, "Error extracting content from #{id}: #{e.inspect}"
    end

    private

    def connection_url
      ActiveFedora.solr_config[:url]
    end
  end
end
