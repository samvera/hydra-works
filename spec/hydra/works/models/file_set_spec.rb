require 'spec_helper'

describe Hydra::Works::FileSet do
  let(:file_set) { described_class.new }

  describe 'Related objects' do
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      file_set.related_objects = [object1]
    end

    it 'persists' do
      expect(file_set.related_objects).to eq [object1]
    end
  end

  describe '#files' do
    let(:file1) { file_set.files.build }
    let(:file2) { file_set.files.build }

    before do
      file_set.save!
      file1.content = "I'm a file"
      file2.content = 'I am too'
      file_set.save!
    end

    subject { described_class.find(file_set.id).files }

    it { is_expected.to eq [file1, file2] }
  end

  describe '#in_works' do
    subject { file_set.in_works }
    let(:generic_work) { Hydra::Works::GenericWork.create }
    before do
      generic_work.ordered_members << file_set
      generic_work.save
    end

    it { is_expected.to eq [generic_work] }
  end
end
