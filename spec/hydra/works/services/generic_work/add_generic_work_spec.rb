require 'spec_helper'

describe Hydra::Works::AddGenericWorkToGenericWork do

  let(:subject) { Hydra::Works::GenericWork::Base.new }

  describe '#call' do
    context 'with acceptable generic_works' do
      let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
      let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
      let(:generic_work3) { Hydra::Works::GenericWork::Base.new }
      let(:generic_work4) { Hydra::Works::GenericWork::Base.new }
      let(:generic_work5) { Hydra::Works::GenericWork::Base.new }
      let(:generic_file1)   { Hydra::Works::GenericFile::Base.new }
      let(:generic_file2)   { Hydra::Works::GenericFile::Base.new }

      context 'with generic_files and generic_works' do
        before do
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
          Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        end

        it 'should add generic_work to generic_work with generic_files and generic_works' do
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work3 )
          expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [generic_work1,generic_work2,generic_work3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr['generic_works_ssim']).to include(generic_work1.id,generic_work2.id,generic_work3.id)
          expect(subject.to_solr['generic_works_ssim']).not_to include(generic_file1.id,generic_file2.id)
          expect(subject.to_solr['generic_files_ssim']).to include(generic_file1.id,generic_file2.id)
          expect(subject.to_solr['generic_files_ssim']).not_to include(generic_work1.id,generic_work2.id,generic_work3.id)
        end
        end
      end

      describe 'aggregates generic_works that implement Hydra::Works::GenericWorkBehavior' do
        before do
          class DummyIncWork < ActiveFedora::Base
            include Hydra::Works::GenericWorkBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncWork) }
        let(:iwork1) { DummyIncWork.new }

        it 'should accept implementing generic_work as a child' do
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, iwork1 )
          expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [iwork1]
        end
      end

      describe 'aggregates generic_works that extend Hydra::Works::GenericWork::Base' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.new }

        it 'should accept extending generic_work as a child' do
          Hydra::Works::AddGenericWorkToGenericWork.call( subject, ework1 )
          expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject ) ).to eq [ework1]
        end
      end
    end

    context 'with unacceptable child generic_works' do
      let(:collection1)      { Hydra::Works::Collection.new }
      let(:generic_file1)    { Hydra::Works::GenericFile::Base.new }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
      let(:pcdm_object1)     { Hydra::PCDM::Object.new }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.new }

      let(:error_message) { 'child_generic_work must be a hydra-works generic work' }

      it 'should NOT aggregate Hydra::Works::Collection in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFile in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, pcdm_object1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic works aggregation' do
        expect{ Hydra::Works::AddGenericWorkToGenericWork.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end
  end
end
