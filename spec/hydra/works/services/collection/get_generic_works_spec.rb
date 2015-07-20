require 'spec_helper'

describe Hydra::Works::GetGenericWorksFromCollection do

  subject { Hydra::Works::Collection.new }

  let(:collection1) { Hydra::Works::Collection.new }
  let(:collection2) { Hydra::Works::Collection.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }

  describe '#call' do
    it 'should return empty array when only collections are aggregated' do
      Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
      Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
      expect(Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq []
    end

    context 'with collections and generic works' do
      before do
        Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
      end

      it 'should only return generic works' do
        expect(Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work1,generic_work2]
      end
   end
  end
end
