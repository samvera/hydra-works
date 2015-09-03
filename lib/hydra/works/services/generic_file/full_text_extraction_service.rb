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
      JSON.parse(fetch)[''].rstrip
    rescue Hydra::Works::FullTextExtractionError => e
      raise e
    rescue => e
      raise Hydra::Works::FullTextExtractionError.new, "Error extracting content from #{id}: #{e.inspect}"
    end

    # send the request to the extract service and return the response if it was successful.
    # TODO: this pulls the whole file into memory. We should stream it from Fedora instead
    # @return [String] the result of calling the extract service
    def fetch
      req = Net::HTTP.new(uri.host, uri.port)
      resp = req.post(uri.to_s, original_file.content, request_headers)
      raise Hydra::Works::FullTextExtractionError.new, "Solr Extract service was unsuccessful. '#{uri}' returned code #{resp.code} for #{id}\n#{resp.body}" unless resp.code == '200'
      original_file.content.rewind if original_file.content.respond_to?(:rewind)

      resp.body
    end

    # @return [Hash] the request headers to send to the Solr extract service
    def request_headers
      { Faraday::Request::UrlEncoded::CONTENT_TYPE => "#{original_file.mime_type};charset=utf-8",
        Faraday::Adapter::CONTENT_LENGTH => original_file.size.to_s }
    end

    # @returns [URI] path to the extract service
    def uri
      @uri ||= URI("#{connection_url}/update/extract?extractOnly=true&wt=json&extractFormat=text")
    end

    private

      def connection_url
        ActiveFedora.solr_config[:url]
      end
  end
end
