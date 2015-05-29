require 'spec_helper'

describe Hydra::Works::AddCollectionToCollection do

  subject { Hydra::Works::Collection.create }

  describe '#call' do
    context 'with acceptable collections' do
      let(:collection1) { Hydra::Works::Collection.create }
      let(:collection2) { Hydra::Works::Collection.create }
      let(:collection3) { Hydra::Works::Collection.create }
      let(:generic_work1)  { Hydra::Works::GenericWork::Base.create }
      let(:generic_work2)  { Hydra::Works::GenericWork::Base.create }

      context 'with collections and generic_works' do
        before do
          Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
          Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
          subject.save
        end

        it 'should add an generic_work to collection with collections and generic_works' do
          Hydra::Works::AddCollectionToCollection.call( subject, collection3 )
          expect( Hydra::Works::GetCollectionsFromCollection.call( subject ) ).to eq [collection1,collection2,collection3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(collection2.id,collection1.id,collection3.id)
          expect(subject.to_solr["collections_ssim"]).to include(collection2.id,collection1.id,collection3.id)
          expect(subject.to_solr["collections_ssim"]).not_to include(generic_work1.id,generic_work2.id)
        end
        end
      end

      describe 'aggregates collections that implement Hydra::Works' do
        before do
          class Kollection < ActiveFedora::Base
            include Hydra::Works::CollectionBehavior
          end
        end
        after { Object.send(:remove_const, :Kollection) }
        let(:kollection1) { Kollection.create }

        it 'should accept implementing collection as a child' do
          Hydra::Works::AddCollectionToCollection.call( subject, kollection1 )
          subject.save
          expect( Hydra::Works::GetCollectionsFromCollection.call( subject ) ).to eq [kollection1]
        end

        it 'should accept implementing collection as a parent' do
          Hydra::Works::AddCollectionToCollection.call( kollection1, collection1 )
          subject.save
          expect( Hydra::Works::GetCollectionsFromCollection.call( kollection1 ) ).to eq [collection1]
        end
      end

      describe 'aggregates collections that extend Hydra::Works' do
        before do
          class Cullection < Hydra::Works::Collection
          end
        end
        after { Object.send(:remove_const, :Cullection) }
        let(:cullection1) { Cullection.create }

        it 'should accept extending collection as a child' do
          Hydra::Works::AddCollectionToCollection.call( subject, cullection1 )
          subject.save
          expect( Hydra::Works::GetCollectionsFromCollection.call( subject ) ).to eq [cullection1]
        end

        it 'should accept extending collection as a parent' do
          Hydra::Works::AddCollectionToCollection.call( cullection1, collection1 )
          subject.save
          expect( Hydra::Works::GetCollectionsFromCollection.call( cullection1 ) ).to eq [collection1]
        end
      end
    end

    context 'with unacceptable child collections' do
      let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
      let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'child_collection must be a hydra-works collection' }

      it 'should NOT aggregate Hydra::Works::GenericWork in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, generic_work1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFile in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, generic_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, pcdm_collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, pcdm_object1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, pcdm_file1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, non_PCDM_object ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in collections aggregation' do
        expect{ Hydra::Works::AddCollectionToCollection.call( subject, af_base_object ) }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with unacceptable parent collections' do
      let(:collection1)      { Hydra::Works::Collection.create }
      let(:generic_work1)    { Hydra::Works::GenericWork::Base.create }
      let(:generic_file1)    { Hydra::Works::GenericFile::Base.create }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
      let(:pcdm_object1)     { Hydra::PCDM::Object.create }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.create }

      let(:error_message) { 'parent_collection must be a hydra-works collection' }

      it 'should NOT accept Hydra::Works::GenericWork as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( generic_work1, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::Works::GenericFile as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( generic_file1, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Collections as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( pcdm_collection1, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Objects as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( pcdm_object1, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept Hydra::PCDM::Files as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( pcdm_file1, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept non-PCDM objects as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( non_PCDM_object, collection1 ) }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT accept AF::Base objects as parent collection' do
        expect{ Hydra::Works::AddCollectionToCollection.call( af_base_object, collection1 ) }.to raise_error(ArgumentError,error_message)
      end
    end

  end

end
