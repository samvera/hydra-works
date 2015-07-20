require 'spec_helper'

describe Hydra::Works::Collection do

  let(:collection1) { Hydra::Works::Collection.new }
  let(:collection2) { Hydra::Works::Collection.new }
  let(:collection3) { Hydra::Works::Collection.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }

  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.collections = [collection2, collection3]
      expect(collection1.collections).to eq [collection2, collection3]
    end
  end

  describe '#generic_works=' do
    it 'should aggregate generic_works' do
      collection1.generic_works = [generic_work1,generic_work2]
      expect(collection1.generic_works).to eq [generic_work1,generic_work2]
    end
  end

  describe 'Related objects' do
    let(:object) { Hydra::PCDM::Object.new }
    let(:collection) { Hydra::Works::Collection.new }

    before do
      collection.related_objects = [object]
    end

    it 'persists' do
      expect(collection.related_objects).to eq [object]
    end
  end
end
