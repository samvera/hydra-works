require 'spec_helper'

describe Hydra::Works::FullTextExtractionService do
  let(:generic_file) { Hydra::Works::GenericFile::Base.new }

  describe 'integration test' do
    before do
      Hydra::Works::UploadFileToGenericFile.call(generic_file, File.open(File.join(fixture_path, 'sample-file.pdf')))
    end
    subject { described_class.run(generic_file) }
    it 'extracts fulltext and stores the results' do
      expect(subject).to include('This is some original content')
    end
  end

  describe "run" do
    let(:generic_file) { double(id: '123') }
    subject { described_class.run(generic_file) }

    context "when it is successful" do
      before do
        allow_any_instance_of(described_class).to receive(:fetch).and_return('{"":"one two three"}')
      end
      it { is_expected.to eq 'one two three' }
    end

    context "when solr raises an error" do
      before do
        allow_any_instance_of(described_class).to receive(:fetch).and_raise(Hydra::Works::FullTextExtractionError.new, "Solr failed")
      end
      it "raises an error" do
        expect { subject }.to raise_error Hydra::Works::FullTextExtractionError, 'Solr failed'
      end
    end

    context "network error" do
      before do
        allow_any_instance_of(described_class).to receive(:fetch).and_raise(Errno::ECONNRESET)
      end
      it "raises an error" do
        expect { subject }.to raise_error Hydra::Works::FullTextExtractionError, 'Error extracting content from 123: #<Errno::ECONNRESET: Connection reset by peer>'
      end
    end
  end

  describe "fetch" do
    let(:generic_file) { double('generic file', id: '123', original_file: original) }
    let(:original) { double(content: content, size: 13, mime_type: 'text/plain') }
    let(:service) { described_class.new(generic_file) }
    subject { service.fetch }
    let(:request) { double }
    let(:response_body) { 'returned by Solr' }
    let(:resp) { double(code: '200', body: response_body) }
    let(:uri) { URI('http://example.com:99/solr/update') }
    let(:content) { 'file contents' }

    before do
      allow(service).to receive(:uri).and_return(URI('http://example.com:99/solr/update'))
      allow(Net::HTTP).to receive(:new).with('example.com', 99).and_return(request)
    end

    context "that is successful" do
      let(:resp) { double(code: '200', body: response_body) }
      it "calls the extraction service" do
        expect(request).to receive(:post).with('http://example.com:99/solr/update', content, "Content-Type" => "text/plain;charset=utf-8", "Content-Length" => "13").and_return(resp)
        expect(subject).to eq response_body
      end
    end

    context "that fails" do
      let(:resp) { double(code: '500', body: response_body) }
      it "raises an error" do
        expect(request).to receive(:post).with('http://example.com:99/solr/update', content, "Content-Type" => "text/plain;charset=utf-8", "Content-Length" => "13").and_return(resp)
        expect { subject }.to raise_error Hydra::Works::FullTextExtractionError, "Solr Extract service was unsuccessful. 'http://example.com:99/solr/update' returned code 500 for 123\nreturned by Solr"
      end
    end
  end

  describe "uri" do
    let(:generic_file) { double }
    let(:service) { described_class.new(generic_file) }
    subject { service.uri }

    it "points at the extraction service" do
      expect(subject).to be_kind_of URI
      expect(subject.to_s).to end_with '/update/extract?extractOnly=true&wt=json&extractFormat=text'
    end
  end
end
