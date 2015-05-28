require 'spec_helper'

describe Hydra::Works::RemoveGenericFileFromGenericWork do

  subject { Hydra::Works::GenericWork::Base.create }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file3) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file4) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file5) { Hydra::Works::GenericFile::Base.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.create }

  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file3 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file4 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file5 )
        subject.save
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject.reload )).to eq [generic_file1,generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_file1 ) ).to eq generic_file1
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject.reload )).to eq [generic_file2,generic_file3,generic_file4,generic_file5]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject.reload )).to eq [generic_work2,generic_work1]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_file5 ) ).to eq generic_file5
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject.reload )).to eq [generic_file1,generic_file2,generic_file3,generic_file4]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject.reload )).to eq [generic_work2,generic_work1]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_file3 ) ).to eq generic_file3
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject.reload )).to eq [generic_file1,generic_file2,generic_file4,generic_file5]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject.reload )).to eq [generic_work2,generic_work1]
      end
    end
  end

  context 'with unacceptable generic files' do
    let(:collection1)    { Hydra::Works::Collection.create }
    let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
    let(:pcdm_object1)     { Hydra::PCDM::Object.create }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_generic_file must be a hydra-works generic file' }

    it 'should NOT remove Hydra::Works::Collection from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::Works::GenericWork from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_work1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Objects from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, pcdm_object1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end

  context 'with unacceptable parent generic work' do
    let(:generic_work2)    { Hydra::Works::GenericWork::Base.create }
    let(:collection1)      { Hydra::Works::Collection.create }
    let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
    let(:pcdm_object1)     { Hydra::PCDM::Object.create }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.create }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'parent_generic_work must be a hydra-works generic work' }

    it 'should NOT accept Hydra::Works::Collection as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::Works::GenericFile as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( generic_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Collections as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( pcdm_collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Objects as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( pcdm_object1, generic_work2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept Hydra::PCDM::Files as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( pcdm_file1, generic_work2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept non-PCDM objects as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( non_PCDM_object, generic_work2 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT accept AF::Base objects as parent generic work' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericWork.call( af_base_object, generic_work2 ) }.to raise_error(error_type,error_message)
    end
  end
end
