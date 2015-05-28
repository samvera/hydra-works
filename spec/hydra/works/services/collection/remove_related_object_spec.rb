require 'spec_helper'

describe Hydra::Works::RemoveRelatedObjectFromCollection do

  subject { Hydra::Works::Collection.create }

  let(:related_object1) { Hydra::PCDM::Object.create }
  let(:related_work2)   { Hydra::Works::GenericWork::Base.create }
  let(:related_file3)   { Hydra::Works::GenericFile::Base.create }
  let(:related_object4) { Hydra::PCDM::Object.create }
  let(:related_work5)   { Hydra::Works::GenericWork::Base.create }

  let(:collection1)   { Hydra::Works::Collection.create }
  let(:collection2)   { Hydra::Works::Collection.create }
  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }


  describe '#call' do
    context 'when multiple related objects' do
      before do
        Hydra::Works::AddRelatedObjectToCollection.call( subject, related_object1 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, related_work2 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
        Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, related_file3 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, related_object4 )
        Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
        Hydra::Works::AddRelatedObjectToCollection.call( subject, related_work5 )
        subject.save
        expect( Hydra::Works::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [related_object1,related_work2,related_file3,related_object4,related_work5]
      end

      it 'should remove first related object' do
        expect( Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, related_object1 ) ).to eq related_object1
        expect( Hydra::Works::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [related_work2,related_file3,related_object4,related_work5]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection1]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work1]
      end

      it 'should remove last related object' do
        expect( Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, related_work5 ) ).to eq related_work5
        expect( Hydra::Works::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [related_object1,related_work2,related_file3,related_object4]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection1]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work1]
      end

      it 'should remove middle related object' do
        expect( Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, related_file3 ) ).to eq related_file3
        expect( Hydra::Works::GetRelatedObjectsFromCollection.call( subject.reload )).to eq [related_object1,related_work2,related_object4,related_work5]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection1]
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work1]
      end
    end
  end

  context 'with unacceptable related object' do
    let(:collection1)      { Hydra::Works::Collection.create }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_related_object must be a pcdm object' }

    it 'should NOT remove Hydra::Works::Collection from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end

  context 'with unacceptable parent collection' do
    let(:related_object2)  { Hydra::PCDM::Object.create }
    let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
    let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
    let(:pcdm_object1)     { Hydra::PCDM::Object.create }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'parent_collection must be a hydra-works collection' }

    it 'should NOT accept Hydra::Works::GenericWork as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( generic_work1, related_object2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::Works::GenericFile as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( generic_file1, related_object2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Collections as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( pcdm_collection1, related_object2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( pcdm_object1, related_object2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Files as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( pcdm_file1, related_object2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept non-PCDM objects as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( non_PCDM_object, related_object2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept AF::Base objects as parent collection' do
      expect{ Hydra::Works::RemoveRelatedObjectFromCollection.call( af_base_object, related_work2 ) }.to raise_error(error_type,error_message)
    end
  end
end
