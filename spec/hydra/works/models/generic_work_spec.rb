require 'spec_helper'

describe Hydra::Works::GenericWork do

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }

  let(:pcdm_file1)       { Hydra::PCDM::File.new }

  describe '#child_generic_works=' do
    it 'should aggregate generic_works' do
      generic_work1.child_generic_works = [generic_work2, generic_work3]
      expect(generic_work1.child_generic_works).to eq [generic_work2, generic_work3]
    end
  end

  describe '#generic_files=' do
    it 'should aggregate generic_files' do
      generic_work1.generic_files = [generic_file1, generic_file2]
      expect(generic_work1.generic_files).to eq [generic_file1, generic_file2]
    end
  end

  describe '#generic_file_ids' do
    it 'should list child generic_file ids' do
      generic_work1.generic_files = [generic_file1, generic_file2]
      expect(generic_work1.generic_file_ids).to eq [generic_file1.id, generic_file2.id]
    end
  end

  context "sub-class" do
    before do
      class TestWork < Hydra::Works::GenericWork::Base
      end
    end

    subject { TestWork.new(generic_files: [generic_file1]) }

    it "should have many generic files" do
      expect(subject.generic_files).to eq [generic_file1]
    end
  end

  describe '#contains' do
    it 'should present as a missing method' do
      expect{ generic_work1.contains = [pcdm_file1] }.to raise_error(NoMethodError,"works can not directly contain files.  You must add a GenericFile to the work's members and add files to that GenericFile.")
    end
  end

  describe 'Related objects' do
    let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      generic_work1.related_objects = [object1]
    end

    it 'persists' do
      expect(generic_work1.related_objects).to eq [object1]
    end
  end

end
