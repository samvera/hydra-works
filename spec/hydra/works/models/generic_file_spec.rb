require 'spec_helper'

describe Hydra::Works::GenericFile::Base do

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }

  describe 'Related objects' do
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      generic_file1.related_objects = [object1]
    end

    it 'persists' do
      expect(generic_file1.related_objects).to eq [object1]
    end
  end

  describe '#files' do
    let(:object) { described_class.create }
    let(:file1) { object.files.build }
    let(:file2) { object.files.build }

    before do
      file1.content = "I'm a file"
      file2.content = "I am too"
      object.save!
    end

    subject { described_class.find(object.id).files }

    it { is_expected.to eq [file1, file2] }
  end
end
