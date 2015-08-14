require 'spec_helper'

describe Hydra::Works::GenerateThumbnail do
  context 'when the object has no original file' do
    let(:error_message) { 'object has no content at original_file from which to generate a thumbnail' }
    let(:object) { double('object', original_file: nil) }
    it 'raises an error' do
      expect(-> { described_class.call(object) }).to raise_error(ArgumentError, error_message)
    end
  end

  context 'when the object has no content at specified location' do
    let(:error_message) { 'object has no content at my_location from which to generate a thumbnail' }
    let(:object) { double('object', my_location: nil) }
    it 'raises an error' do
      expect(-> { described_class.call(object, content: :my_location) }).to raise_error(ArgumentError, error_message)
    end
  end
end
