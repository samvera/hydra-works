require 'spec_helper'

describe Hydra::Works::RemoveRelatedObjectFromGenericFile do

  subject { Hydra::Works::GenericFile::Base.new }

  let(:related_object1) { Hydra::PCDM::Object.new }
  let(:related_work2)   { Hydra::Works::GenericWork::Base.new }
  let(:related_file3)   { Hydra::Works::GenericFile::Base.new }
  let(:related_object4) { Hydra::PCDM::Object.new }
  let(:related_work5)   { Hydra::Works::GenericWork::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }


  describe '#call' do
    context 'when multiple related objects' do
      before do
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, related_object1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, related_work2 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, related_file3 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, related_object4 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, related_work5 )
        expect( Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )).to eq [related_object1,related_work2,related_file3,related_object4,related_work5]
      end

      it 'should remove first related object' do
        expect( Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, related_object1 ) ).to eq related_object1
        expect( Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )).to eq [related_work2,related_file3,related_object4,related_work5]
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file2,generic_file1]
      end

      it 'should remove last related object' do
        expect( Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, related_work5 ) ).to eq related_work5
        expect( Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )).to eq [related_object1,related_work2,related_file3,related_object4]
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file2,generic_file1]
      end

      it 'should remove middle related object' do
        expect( Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, related_file3 ) ).to eq related_file3
        expect( Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )).to eq [related_object1,related_work2,related_object4,related_work5]
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file2,generic_file1]
      end
    end
  end

  context 'with unacceptable related object' do
    let(:collection1)      { Hydra::Works::Collection.new }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.new }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_related_object must be a pcdm object' }

    it 'should NOT remove Hydra::Works::Collection from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from related_objects aggregation' do
      expect{ Hydra::Works::RemoveRelatedObjectFromGenericFile.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end
end
