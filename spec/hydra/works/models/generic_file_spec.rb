require 'spec_helper'

describe Hydra::Works::GenericFile::Base do

  let(:generic_file1) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file3) { Hydra::Works::GenericFile::Base.create }

  describe '#generic_files=' do
    it 'should aggregate generic_files' do
      generic_file1.generic_files = [generic_file2, generic_file3]
      generic_file1.save
      expect(generic_file1.generic_files).to eq [generic_file2, generic_file3]
    end
  end

  describe 'Related objects' do
    let(:object1) { Hydra::PCDM::Object.create }

    before do
      generic_file1.related_objects = [object1]
      generic_file1.save
    end

    it 'persists' do
      expect(generic_file1.reload.related_objects).to eq [object1]
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
