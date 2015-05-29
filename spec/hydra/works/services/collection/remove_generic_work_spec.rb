require 'spec_helper'

describe Hydra::Works::RemoveGenericWorkFromCollection do

  subject { Hydra::Works::Collection.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work4) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work5) { Hydra::Works::GenericWork::Base.create }

  let(:collection1) { Hydra::Works::Collection.create }
  let(:collection2) { Hydra::Works::Collection.create }


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
        subject.save
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work1,generic_work2,generic_work3,generic_work4,generic_work5]
      end

      it 'should remove first generic work' do
        expect( Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_work1 ) ).to eq generic_work1
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work2,generic_work3,generic_work4,generic_work5]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection1]
      end

      it 'should remove last generic work' do
        expect( Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_work5 ) ).to eq generic_work5
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work1,generic_work2,generic_work3,generic_work4]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection1]
      end

      it 'should remove middle generic work' do
        expect( Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_work3 ) ).to eq generic_work3
        expect( Hydra::Works::GetGenericWorksFromCollection.call( subject.reload )).to eq [generic_work1,generic_work2,generic_work4,generic_work5]
        expect( Hydra::Works::GetCollectionsFromCollection.call( subject.reload )).to eq [collection2,collection1]
      end
    end
  end

  context 'with unacceptable generic works' do
    let(:collection1)    { Hydra::Works::Collection.create }
    let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
    let(:pcdm_object1)     { Hydra::PCDM::Object.create }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_generic_work must be a hydra-works generic work' }

    it 'should NOT remove Hydra::Works::Collection from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::Works::GenericFile from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, pcdm_object1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end

  context 'with unacceptable parent collection' do
    let(:generic_work2)    { Hydra::Works::GenericWork::Base.create }
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
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( generic_work1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::Works::GenericFile as parent collection' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( generic_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Collections as parent collection' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( pcdm_collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( pcdm_object1, generic_work2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Files as parent collection' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( pcdm_file1, generic_work2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept non-PCDM objects as parent collection' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( non_PCDM_object, generic_work2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept AF::Base objects as parent collection' do
      expect{ Hydra::Works::RemoveGenericWorkFromCollection.call( af_base_object, generic_work2 ) }.to raise_error(error_type,error_message)
    end
  end
end
