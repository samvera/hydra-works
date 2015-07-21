require 'spec_helper'

describe Hydra::Works::AddGenericFileToGenericFile do

  let(:subject) { Hydra::Works::GenericFile::Base.new }

  describe '#call' do
    context 'with acceptable generic_files' do
      let(:generic_file1)   { Hydra::Works::GenericFile::Base.new }
      let(:generic_file2)   { Hydra::Works::GenericFile::Base.new }
      let(:generic_file3)   { Hydra::Works::GenericFile::Base.new }
      let(:generic_file4)   { Hydra::Works::GenericFile::Base.new }
      let(:generic_file5)   { Hydra::Works::GenericFile::Base.new }

      it 'should aggregate generic_files in a sub-generic_file of a generic_file' do
        Hydra::Works::AddGenericFileToGenericFile.call( generic_file1, generic_file2 )
        Hydra::Works::AddGenericFileToGenericFile.call( generic_file2, generic_file3 )
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( generic_file1 ) ).to eq [generic_file2]
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( generic_file2 ) ).to eq [generic_file3]
      end

      it 'should allow generic_files to repeat' do
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject ) ).to eq [generic_file1,generic_file2,generic_file1]
      end

      context 'with files and generic_files' do
        let(:file1) { subject.files.build }
        let(:file2) { subject.files.build }

        before do
          subject.save
          file1.content = "I'm a file"
          file2.content = "I am too"
          Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
          Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
        end

        it 'should add generic_file to generic_file with generic_files and files' do
          Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file3 )
          expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject ) ).to eq [generic_file1,generic_file2,generic_file3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_files_ssim"]).to include(generic_file2.id,generic_file1.id)
          expect(subject.to_solr["generic_files_ssim"]).not_to include(file1.id,file2.id)
          expect(subject.to_solr["files_ssim"]).to include(file1.id,file2.id)
          expect(subject.to_solr["files_ssim"]).not_to include(generic_file1.id,generic_file2.id)
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
        let(:ifile1) { DummyIncFile.new }

        it 'should accept implementing generic_file as a child' do
          Hydra::Works::AddGenericFileToGenericFile.call( subject, ifile1 )
          expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject ) ).to eq [ifile1]
        end
      end

      describe 'aggregates generic_files that extend Hydra::Works::GenericFile::Base' do
        before do
          class DummyExtFile < Hydra::Works::GenericFile::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtFile) }
        let(:efile1) { DummyExtFile.new }

        it 'should accept extending generic_file as a child' do
          Hydra::Works::AddGenericFileToGenericFile.call( subject, efile1 )
          expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject ) ).to eq [efile1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @generic_file102      = Hydra::Works::GenericFile::Base.new

        @works_collection101  = Hydra::Works::Collection.new
        @generic_work101      = Hydra::Works::GenericWork::Base.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_PCDM_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic files' do

        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(GenericWork::Base|Collection) with ID:  was expected to works_generic_file\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `works_generic_file\?' for .*/ }

        it 'should NOT aggregate Hydra::Works::Collection in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericFile.call( @generic_file102, @works_collection101 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericWork in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericWork.call( @generic_file102, @generic_work101 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericFile.call( @generic_file102, @pcdm_collection101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericFile.call( @generic_file102, @pcdm_object101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericFile.call( @generic_file102, @pcdm_file101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericFile.call( @generic_file102, @non_PCDM_object ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in generic files aggregation' do
          expect{ Hydra::Works::AddGenericFileToGenericFile.call( @generic_file102, @af_base_object ) }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end
end
