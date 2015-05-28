require 'spec_helper'

describe Hydra::Works::AddRelatedObjectToGenericFile do

  let(:subject) { Hydra::Works::GenericFile::Base.create }

  describe '#call' do

    context 'with acceptable related objects' do
      let(:object1) { Hydra::PCDM::Object.create }
      let(:object2) { Hydra::PCDM::Object.create }
      let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
      let(:generic_work2) { Hydra::Works::GenericWork::Base.create }
      let(:generic_file1) { Hydra::Works::GenericFile::Base.create }
      let(:generic_file2) { Hydra::Works::GenericFile::Base.create }

      it 'should add various types of related objects to generic_file' do
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, generic_work1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object1 )
        related_objects = Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )
        expect( related_objects.include? generic_work1 ).to be true
        expect( related_objects.include? generic_file1 ).to be true
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.size ).to eq 3
      end

      context 'with files and generic_files' do
        let(:file1) { subject.files.build }
        let(:file2) { subject.files.build }

        before do
          file1.content = "I'm a file"
          file2.content = "I am too"
          Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
          Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object1 )
          subject.save!
        end

        it 'should add a related object to a generic_file with files and generic_files' do
          Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object2 )
          related_objects = Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )
          expect( related_objects.include? object1 ).to be true
          expect( related_objects.include? object2 ).to be true
          expect( related_objects.size ).to eq 2
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_files_ssim"]).to include(generic_file2.id,generic_file1.id)
          expect(subject.to_solr["generic_files_ssim"]).not_to include(object1.id,object2.id,file1.id,file2.id)
          expect(subject.to_solr["files_ssim"]).to include(file1.id,file2.id)
          expect(subject.to_solr["files_ssim"]).not_to include(object1.id,object2.id,generic_file1.id,generic_file2.id)
          expect(subject.to_solr["related_objects_ssim"]).to include(object1.id,object2.id)
          expect(subject.to_solr["related_objects_ssim"]).not_to include(generic_file2.id,generic_file1.id,file1.id,file2.id)
        end
        end
      end
    end

    context 'with unacceptable child related objects' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'should NOT aggregate Hydra::Works::Collection in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in related objects aggregation' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with unacceptable parent generic work' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_object2)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'parent_generic_file must be a hydra-works generic file' }

      it 'should NOT accept Hydra::Works::Collection as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( collection1, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::Works::GenericWork as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( generic_work1, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Collections as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( pcdm_collection1, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Objects as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( pcdm_object1, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( pcdm_file1, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( non_PCDM_object, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent generic file' do
        expect{ Hydra::Works::AddRelatedObjectToGenericFile.call( af_base_object, pcdm_object2 ) }.to raise_error(ArgumentError,error_message)
      end
    end


    context 'with invalid behaviors' do
      let(:object1) { Hydra::PCDM::Object.create }
      let(:object2) { Hydra::PCDM::Object.create }

      it 'should NOT allow related objects to repeat' do
        skip 'skipping this test because issue pcdm#92 needs to be addressed' do
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object2 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object1 )
        related_objects = Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end
      end
    end
  end
end
