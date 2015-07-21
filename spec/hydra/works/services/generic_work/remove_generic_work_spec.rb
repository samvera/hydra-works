require 'spec_helper'

describe Hydra::Works::RemoveGenericWorkFromGenericWork do

  subject { Hydra::Works::GenericWork::Base.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work4) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work5) { Hydra::Works::GenericWork::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }


  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work3 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work4 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work5 )
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work1,generic_work2,generic_work3,generic_work4,generic_work5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_work1 ) ).to eq generic_work1
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work2,generic_work3,generic_work4,generic_work5]
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file1]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_work5 ) ).to eq generic_work5
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work1,generic_work2,generic_work3,generic_work4]
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file1]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_work3 ) ).to eq generic_work3
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work1,generic_work2,generic_work4,generic_work5]
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file1]
      end
    end
  end

  context 'with unacceptable generic works' do
    let(:collection1)    { Hydra::Works::Collection.new }
    let(:generic_file1)    { Hydra::Works::GenericFile::Base.new }
    let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
    let(:pcdm_object1)     { Hydra::PCDM::Object.new }
    let(:pcdm_file1)       { Hydra::PCDM::File.new }
    let(:non_PCDM_object)  { "I'm not a PCDM object" }
    let(:af_base_object)   { ActiveFedora::Base.new }

    let(:error_type)    { ArgumentError }
    let(:error_message) { 'child_generic_work must be a hydra-works generic work' }

    it 'should NOT remove Hydra::Works::Collection from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::Works::GenericFile from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Collections from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, pcdm_object1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove Hydra::PCDM::Files from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, pcdm_file1 ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove non-PCDM objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, non_PCDM_object ) }.to raise_error(error_type,error_message)
    end

    it 'should NOT remove AF::Base objects from generic_works aggregation' do
      expect{ Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, af_base_object ) }.to raise_error(error_type,error_message)
    end
  end
end
