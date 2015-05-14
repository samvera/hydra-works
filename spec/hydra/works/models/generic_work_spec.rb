require 'spec_helper'

describe Hydra::Works::GenericWork do

  let(:generic_work1) { Hydra::Works::GenericWork.create }
  let(:generic_work2) { Hydra::Works::GenericWork.create }
  let(:generic_work3) { Hydra::Works::GenericWork.create }

  let(:generic_file1) { Hydra::Works::GenericFile.create }
  let(:generic_file2) { Hydra::Works::GenericFile.create }

  let(:pcdm_file1)       { Hydra::PCDM::File.new }

  describe '#generic_works=' do
    it 'should aggregate generic_works' do
      generic_work1.generic_works = [generic_work2, generic_work3]
      generic_work1.save
      expect(generic_work1.generic_works).to eq [generic_work2, generic_work3]
    end
  end

  describe '#generic_files=' do
    it 'should aggregate generic_files' do
      generic_work1.generic_files = [generic_file1, generic_file2]
      generic_work1.save
      expect(generic_work1.generic_files).to eq [generic_file1, generic_file2]
    end
  end

  describe '#contains' do
    it 'should present as a missing method' do
      expect{ generic_work1.contains = [pcdm_file1] }.to raise_error(NoMethodError,"works can not contain files")
    end
  end

  describe 'Related objects' do
    let(:generic_work1) { Hydra::Works::GenericWork.create }
    let(:object1) { Hydra::PCDM::Object.create }

    before do
      generic_work1.related_objects = [object1]
      generic_work1.save
    end

    it 'persists' do
      expect(generic_work1.reload.related_objects).to eq [object1]
    end
  end

end
