require 'spec_helper'

describe Hydra::Works::GenericWork do
  
  describe "#save" do
    it 'is a Hydra::PCDM::Object' do
      work = Hydra::Works::GenericWork.create
      expect(work.save).to be true

      # Waiting for PR with this method be merged into master
      # expect(Hydra::PCDM.object? work).to be true
      expect(work.resource.type.include? RDFVocabularies::PCDMTerms.Object).to be true
    end
  end

  describe '#generic_files=' do
    it 'should aggregate generic files' do
      work = Hydra::Works::GenericWork.create
      file1 = Hydra::Works::GenericFile.create
      file2 = Hydra::Works::GenericFile.create
      work.generic_files = [file1, file2]
      work.save
      expect(work.generic_files).to eq [file1, file2]
    end

    it 'should not aggregate other objects' do
      work = Hydra::Works::GenericWork.create
      collection1 = Hydra::Works::Collection.create
      collection2 = Hydra::Works::Collection.create
      expect{ work.generic_files = [collection1, collection2] }.to raise_error(ArgumentError,"each file must be a Hydra::Works::GenericFile")
    end
  end

  describe '#generic_works=' do
    xit 'should aggregate generic works' do
      work = Hydra::Works::GenericWork.create
      work1 = Hydra::Works::GenericWork.create
      work2 = Hydra::Works::GenericWork.create
      work.generic_works = [work1, work2]
      work.save
      expect(work.generic_works).to eq [work1, work2]
    end

    xit 'should not aggregate other objects' do
      work = Hydra::Works::GenericWork.create
      collection1 = Hydra::Works::Collection.create
      collection2 = Hydra::Works::Collection.create
      expect{ work.generic_works = [collection1, collection2] }.to raise_error(ArgumentError,"each work must be a Hydra::Works::GenericWork")
    end
  end

end