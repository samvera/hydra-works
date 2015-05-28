require 'spec_helper'

describe Hydra::Works::AddGenericFileToGenericWork do

  let(:subject) { Hydra::Works::GenericWork::Base.create }

  describe '#call' do
    context 'with acceptable generic_works' do
      let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
      let(:generic_work2) { Hydra::Works::GenericWork::Base.create }
      let(:generic_file1)   { Hydra::Works::GenericFile::Base.create }
      let(:generic_file2)   { Hydra::Works::GenericFile::Base.create }
      let(:generic_file3)   { Hydra::Works::GenericFile::Base.create }

      context 'with generic_files and generic_works' do
        before do
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
          subject.save
        end

        it 'should add generic_file to generic_work with generic_files and generic_works' do
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file3 )
          expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject ) ).to eq [generic_file1,generic_file2,generic_file3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(generic_file1.id,generic_file2.id,generic_file3.id)
          expect(subject.to_solr["generic_files_ssim"]).to include(generic_file1.id,generic_file2.id,generic_file3.id)
          expect(subject.to_solr["generic_files_ssim"]).not_to include(generic_work1.id,generic_work2.id)
        end
        end
      end

      describe 'aggregates generic_files that implement Hydra::Works::GenericFileBehavior' do
        before do
          class DummyIncFile < ActiveFedora::Base
            include Hydra::Works::GenericFileBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncFile) }
        let(:ifile1) { DummyIncFile.create }

        it 'should accept implementing generic_file as a child' do
          Hydra::Works::AddGenericFileToGenericWork.call( subject, ifile1 )
          subject.save
          expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject ) ).to eq [ifile1]
        end

      end

      describe 'aggregates generic_files that extend Hydra::Works::GenericFile::Base' do
        before do
          class DummyExtFile < Hydra::Works::GenericFile::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtFile) }
        let(:efile1) { DummyExtFile.create }

        it 'should accept extending generic_file as a child' do
          Hydra::Works::AddGenericFileToGenericWork.call( subject, efile1 )
          subject.save
          expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject ) ).to eq [efile1]
        end
      end
    end

    context 'with unacceptable child generic_files' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'child_generic_file must be a hydra-works generic file' }

      it 'should NOT aggregate Hydra::Works::Collection in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericWork in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_work1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, pcdm_object1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic files aggregation' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with unacceptable parent generic works' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
      let(:generic_work2)    { Hydra::Works::GenericWork::Base.create }
      let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'parent_generic_work must be a hydra-works generic work' }

      it 'should NOT accept Hydra::Works::Collection as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::Works::GenericFile as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( generic_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Collections as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( pcdm_collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Objects as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( pcdm_object1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( pcdm_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( non_PCDM_object, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent generic work' do
        expect{ Hydra::Works::AddGenericFileToGenericWork.call( af_base_object, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end
    end

  end

end
