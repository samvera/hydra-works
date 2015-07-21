require 'spec_helper'

describe Hydra::Works::RemoveGenericFileFromGenericFile do

  subject { Hydra::Works::GenericFile::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file3) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file4) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file5) { Hydra::Works::GenericFile::Base.new }

  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file3 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file4 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file5 )
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_file1 ) ).to eq generic_file1
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_file5 ) ).to eq generic_file5
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2,generic_file3,generic_file4]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_file3 ) ).to eq generic_file3
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2,generic_file4,generic_file5]
      end
    end
  end

  context 'with unacceptable generic files' do
    let(:collection1)    { Hydra::Works::Collection.new }
    let(:generic_work1)    { Hydra::Works::GenericWork::Base.new }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
    let(:pcdm_object1)     { Hydra::PCDM::Object.new }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.new }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_generic_file must be a hydra-works generic file' }

    it 'should NOT remove Hydra::Works::Collection from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::Works::GenericWork from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_work1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Objects from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, pcdm_object1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from generic_files aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end
end
