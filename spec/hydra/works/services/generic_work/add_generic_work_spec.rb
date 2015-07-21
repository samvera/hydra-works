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

    context 'with unacceptable inputs' do
      before(:all) do
        @generic_work102      = Hydra::Works::GenericWork::Base.new

        @works_collection101  = Hydra::Works::Collection.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_PCDM_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic works' do

        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(GenericFile::Base|Collection) with ID:  was expected to works_generic_work\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `works_generic_work\?' for .*/ }

        it 'should NOT aggregate Hydra::Works::Collection in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @works_collection101 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericFile in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @generic_file101 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @pcdm_collection101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @pcdm_object101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @pcdm_file101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @non_PCDM_object ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in generic works aggregation' do
          expect{ Hydra::Works::AddGenericWorkToGenericWork.call( @generic_work102, @af_base_object ) }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end
end
