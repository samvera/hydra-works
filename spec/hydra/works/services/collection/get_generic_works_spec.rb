require 'spec_helper'

describe Hydra::Works::GetGenericWorksFromCollection do

  subject { Hydra::Works::Collection.create }

  let(:collection1) { Hydra::Works::Collection.create }
  let(:collection2) { Hydra::Works::Collection.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.create }

  describe '#call' do
    it 'should return empty array when only collections are aggregated' do
      Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
      Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
      subject.save
      expect(Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq []
    end

    context 'with collections and generic works' do
      before do
        Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
        subject.save
      end

      it 'should only return generic works' do
        expect(Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work1,generic_work2]
      end
   end
  end
end
