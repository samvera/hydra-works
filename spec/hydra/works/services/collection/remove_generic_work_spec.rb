require 'spec_helper'

describe Hydra::Works::RemoveGenericWorkFromCollection do

  subject { Hydra::Works::Collection.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work4) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work5) { Hydra::Works::GenericWork::Base.new }

  let(:collection1) { Hydra::Works::Collection.new }
  let(:collection2) { Hydra::Works::Collection.new }


  describe '#call' do
    context 'when multiple generic works' do
      before do
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work3 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work4 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work5 )
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work1,generic_work2,generic_work3,generic_work4,generic_work5]
      end

      it 'should remove first generic work' do
        expect( Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_work1 ) ).to eq generic_work1
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work2,generic_work3,generic_work4,generic_work5]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection2,collection1]
      end

      it 'should remove last generic work' do
        expect( Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_work5 ) ).to eq generic_work5
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work1,generic_work2,generic_work3,generic_work4]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection2,collection1]
      end

      it 'should remove middle generic work' do
        expect( Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_work3 ) ).to eq generic_work3
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject )).to eq [generic_work1,generic_work2,generic_work4,generic_work5]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject )).to eq [collection2,collection1]
      end
    end
  end
end
