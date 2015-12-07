require 'spec_helper'

describe Hydra::Works::FileSet do
  let(:generic_file1) { described_class.new }

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
      file2.content = 'I am too'
      object.save!
    end

    subject { described_class.find(object.id).files }

    it { is_expected.to eq [file1, file2] }
  end

  describe 'parent work accessors' do
    let(:generic_work1) { Hydra::Works::GenericWork.create }
    before do
      generic_work1.ordered_members << generic_file1
      generic_work1.save
    end

    it 'has parents' do
      expect(generic_file1.member_of).to eq [generic_work1]
    end
    it 'has a parent work' do
      expect(generic_file1.in_works).to eq [generic_work1]
    end
  end
end
