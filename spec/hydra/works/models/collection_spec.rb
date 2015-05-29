require 'spec_helper'

describe Hydra::Works::Collection do

  let(:collection1) { Hydra::Works::Collection.create }
  let(:collection2) { Hydra::Works::Collection.create }
  let(:collection3) { Hydra::Works::Collection.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.create }

  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.collections = [collection2, collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2, collection3]
    end
  end

  describe '#generic_works=' do
    it 'should aggregate generic_works' do
      collection1.generic_works = [generic_work1,generic_work2]
      collection1.save
      expect(collection1.generic_works).to eq [generic_work1,generic_work2]
    end
  end

  describe 'Related objects' do
    let(:object) { Hydra::PCDM::Object.create }
    let(:collection) { Hydra::Works::Collection.create }

    before do
      collection.related_objects = [object]
      collection.save
    end

    it 'persists' do
      expect(collection.reload.related_objects).to eq [object]
    end
  end
end
