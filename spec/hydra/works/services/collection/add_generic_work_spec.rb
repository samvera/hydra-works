require 'spec_helper'

describe Hydra::Works::AddGenericWorkToCollection do

  let(:subject) { Hydra::Works::Collection.create }

  describe '#call' do
    context 'with acceptable generic_works' do
      let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
      let(:generic_work2) { Hydra::Works::GenericWork::Base.create }
      let(:generic_work3) { Hydra::Works::GenericWork::Base.create }
      let(:collection1)   { Hydra::Works::Collection.create }
      let(:collection2)   { Hydra::Works::Collection.create }

      context 'with collections and generic_works' do
        before do
          Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
          Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
          subject.save
        end

        it 'should add generic_work to collection with collections and generic_works' do
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work3 )
          expect( Hydra::Works::GetGenericWorksFromCollection.call( subject ) ).to eq [generic_work1,generic_work2,generic_work3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id,generic_work3.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(collection2.id,collection1.id)
          expect(subject.to_solr["collections_ssim"]).to include(collection2.id,collection1.id)
          expect(subject.to_solr["collections_ssim"]).not_to include(generic_work1.id,generic_work2.id,generic_work3.id)
        end
        end
      end

      describe 'aggregates generic_works that implement Hydra::Works' do
        before do
          class DummyIncWork < ActiveFedora::Base
            include Hydra::Works::GenericWorkBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncWork) }
        let(:iwork1) { DummyIncWork.create }

        it 'should accept implementing generic_work as a child' do
          Hydra::Works::AddGenericWorkToCollection.call( subject, iwork1 )
          subject.save
          expect( Hydra::Works::GetGenericWorksFromCollection.call( subject ) ).to eq [iwork1]
        end

      end

      describe 'aggregates generic_works that extend Hydra::Works' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.create }

        it 'should accept extending generic_work as a child' do
          Hydra::Works::AddGenericWorkToCollection.call( subject, ework1 )
          subject.save
          expect( Hydra::Works::GetGenericWorksFromCollection.call( subject ) ).to eq [ework1]
        end
      end
    end

    context 'with unacceptable child generic_works' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'child_generic_work must be a hydra-works generic work' }

      it 'should NOT aggregate Hydra::Works::Collection in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFile in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, pcdm_object1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in hydra works collections aggregation' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with unacceptable parent collections' do
      let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
      let(:generic_work2)    { Hydra::Works::GenericWork::Base.create }
      let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'parent_collection must be a hydra-works collection' }

      it 'should NOT accept Hydra::Works::GenericWork as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( generic_work1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::Works::GenericFile as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( generic_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Collections as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( pcdm_collection1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( pcdm_object1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( pcdm_file1, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( non_PCDM_object, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ Hydra::Works::AddGenericWorkToCollection.call( af_base_object, generic_work2 ) }.to raise_error(ArgumentError,error_message)
      end
    end

  end

end
