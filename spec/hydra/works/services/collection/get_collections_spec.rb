require 'spec_helper'

describe Hydra::Works::GetCollectionsFromCollection do

  subject { Hydra::Works::Collection.new }

  let(:collection1) { Hydra::Works::Collection.new }
  let(:collection2) { Hydra::Works::Collection.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }

  describe '#call' do
    it 'should return empty array when only generic_works are aggregated' do
      Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
      Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
      expect(Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq []
    end

    context 'with other collections & generic_works' do
      before do
        Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
      end

      it 'should only return collections' do
        expect(Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2]
      end
   end
  end
end
