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
        subject.save
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection3,collection4,collection5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveCollectionFromCollection.call( subject, collection1 ) ).to eq collection1
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection3,collection4,collection5]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work2,generic_work1]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveCollectionFromCollection.call( subject, collection5 ) ).to eq collection5
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection3,collection4]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work2,generic_work1]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveCollectionFromCollection.call( subject, collection3 ) ).to eq collection3
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection1,collection2,collection4,collection5]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work2,generic_work1]
      end
    end
  end

  context 'with unacceptable collections' do
    let(:generic_work1)    { Hydra::Works::GenericWork::Base.new }
    let(:generic_file1)    { Hydra::Works::GenericFile::Base.new }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
    let(:pcdm_object1)     { Hydra::PCDM::Object.new }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.new }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_collection must be a hydra-works collection' }

    it 'should NOT remove Hydra::Works::GenericWork from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, generic_work1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::Works::GenericFile from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Objects from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, pcdm_object1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from collections aggregation' do
      expect{ Hydra::Works::RemoveCollectionFromCollection.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end
end
