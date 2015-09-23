require 'spec_helper'

describe Hydra::Works::GenerateExtractedText do
  context 'when the object has no original file' do
    let(:error_message) { 'object has no content at original_file from which to generate extracted text' }
    let(:object) { double('object', original_file: nil) }
    it 'raises an error' do
      expect(-> { described_class.call(object) }).to raise_error(ArgumentError, error_message)
    end
  end

  context 'when the object has no content at specified location' do
    let(:error_message) { 'object has no content at my_location from which to generate extracted text' }
    let(:object) { double('object', my_location: nil) }
    it 'raises an error' do
      expect(-> { described_class.call(object, content: :my_location) }).to raise_error(ArgumentError, error_message)
    end
  end

  context 'when the object has original file' do
    let(:generic_file) { Hydra::Works::GenericFile::Base.new }
    before do
      Hydra::Works::UploadFileToGenericFile.call(generic_file, File.open(File.join(fixture_path, 'sample-file.pdf')))
    end
    subject { described_class.call(generic_file) }
    it 'extracts fulltext and stores the results' do
      expect(subject.extracted_text.content).to include('This is some original content')
    end
  end
end
