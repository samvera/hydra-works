module Hydra::Works
  # Extract the full text from the content using Solr's extract handler
  class FullTextExtractionService
    # @param [GenericFile] generic_file
    # @param [String] file_path for a local file
    def self.run(generic_file, file_path = nil)
      new(generic_file, file_path).extract
    end

    delegate :original_file, :id, to: :@generic_file

    attr_reader :file_path

    # @param [GenericFile] generic_file
    # @param [String] file_path for a local file
    def initialize(generic_file, file_path)
      @generic_file = generic_file
      @file_path = file_path
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
      resp = req.post(uri.to_s, file_content, request_headers)
      raise Hydra::Works::FullTextExtractionError.new, "Solr Extract service was unsuccessful. '#{uri}' returned code #{resp.code} for #{id}\n#{resp.body}" unless resp.code == '200'
      file_content.rewind if file_content.respond_to?(:rewind)

      resp.body
    end

    def file_content
      @content ||= if file_path
                     File.open(file_path).read
                   else
                     original_file.content
                   end
    end

    # @return [Hash] the request headers to send to the Solr extract service
    def request_headers
      { Faraday::Request::UrlEncoded::CONTENT_TYPE => "#{mime_type};charset=utf-8",
        Faraday::Adapter::CONTENT_LENGTH => original_file.size.to_s }
    end

    def mime_type
      original_file.try(:mime_type)
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
