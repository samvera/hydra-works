require 'spec_helper'

describe Hydra::Works::FullTextExtractionService do
  let(:generic_file) { Hydra::Works::GenericFile::Base.new }

  describe '#run' do
    let(:service_instance) { double }
    it 'creates an instance of the service and calls .extract on it' do
      expect(described_class).to receive(:new).with(generic_file).and_return(service_instance)
      expect(service_instance).to receive(:extract)
      described_class.run(generic_file)
    end
  end

  describe 'extract', unless: ENV['TRAVIS'] do
    subject { described_class.new(generic_file) }
    before do
      Hydra::Works::UploadFileToGenericFile.call(generic_file, File.open(File.join(fixture_path, 'sample-file.pdf')))
    end

    it 'extracts fulltext and stores the results' do
      subject.extract
      expect(subject.original_file.content).to start_with('%PDF-1.3')
    end
  end
end
