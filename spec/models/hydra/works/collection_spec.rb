require 'spec_helper'

describe Hydra::Works::Collection do

  describe "#save" do
    it 'is a Hydra::PCDM::Collection' do
      col = Hydra::Works::Collection.create
      expect(col.save).to be true
      
      # Waiting for PR with this method be merged into master
      # expect(Hydra::PCDM.collection? col).to be true
      expect(col.resource.type.include? RDFVocabularies::PCDMTerms.Collection).to be true
    end
  end

  describe "#generic works=" do
    it 'aggregates Generic Works' do
      col = Hydra::Works::Collection.create
      work1 = Hydra::Works::GenericWork.create
      work2 = Hydra::Works::GenericWork.create
      col.generic_works = [work1, work2]
      col.save
      expect(col.save).to be true
    end

    it 'should not aggregate other Objects' do
      col = Hydra::Works::Collection.create
      file1 = Hydra::Works::GenericFile.create
      expect{ col.generic_works = [file1] }.to raise_error(ArgumentError,"each object must be a Hydra::Works::GenericWork")
    end
  end

  describe "#collections=" do
    xit 'aggregates other Collections' do
    end

    xit 'should not aggregate other Objects as collections' do
    end
  end

end