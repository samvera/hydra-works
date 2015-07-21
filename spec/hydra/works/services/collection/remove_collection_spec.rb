require 'spec_helper'

describe Hydra::Works::RemoveCollectionFromCollection do

  subject { Hydra::Works::Collection.new }

    let(:collection1) { Hydra::Works::Collection.new }
    let(:collection2) { Hydra::Works::Collection.new }
    let(:collection3) { Hydra::Works::Collection.new }
    let(:collection4) { Hydra::Works::Collection.new }
    let(:collection5) { Hydra::Works::Collection.new }

    let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
    let(:generic_work2) { Hydra::Works::GenericWork::Base.new }


  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection3 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection4 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection5 )
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection3,collection4,collection5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection2,collection3,collection4,collection5]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work2,generic_work1]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveCollectionFromCollection.call( subject, collection5 ) ).to eq collection5
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection3,collection4]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work2,generic_work1]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveCollectionFromCollection.call( subject, collection3 ) ).to eq collection3
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection1,collection2,collection4,collection5]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work2,generic_work1]
      end
    end
  end
end
