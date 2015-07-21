require 'spec_helper'

describe Hydra::Works::AddCollectionToCollection do

  subject { Hydra::Works::Collection.new }

  describe '#call' do
    context 'with acceptable collections' do
      let(:collection1) { Hydra::Works::Collection.new }
      let(:collection2) { Hydra::Works::Collection.new }
      let(:collection3) { Hydra::Works::Collection.new }
      let(:generic_work1)  { Hydra::Works::GenericWork::Base.new }
      let(:generic_work2)  { Hydra::Works::GenericWork::Base.new }

      context 'with collections and generic_works' do
        before do
          Hydra::Works::AddCollectionToCollection.call( subject, collection1 )
          Hydra::Works::AddCollectionToCollection.call( subject, collection2 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work1 )
          Hydra::Works::AddGenericWorkToCollection.call( subject, generic_work2 )
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
        let(:kollection1) { Kollection.new }

        it 'should accept implementing collection as a child' do
          Hydra::Works::AddCollectionToCollection.call( subject, kollection1 )
          expect( Hydra::Works::GetCollectionsFromCollection.call( subject ) ).to eq [kollection1]
        end

        it 'should accept implementing collection as a parent' do
          Hydra::Works::AddCollectionToCollection.call( kollection1, collection1 )
          expect( Hydra::Works::GetCollectionsFromCollection.call( kollection1 ) ).to eq [collection1]
        end
      end

      describe 'aggregates collections that extend Hydra::Works' do
        before do
          class Cullection < Hydra::Works::Collection
          end
        end
        after { Object.send(:remove_const, :Cullection) }
        let(:cullection1) { Cullection.new }

        it 'should accept extending collection as a child' do
          Hydra::Works::AddCollectionToCollection.call( subject, cullection1 )
          expect( Hydra::Works::GetCollectionsFromCollection.call( subject ) ).to eq [cullection1]
        end

        it 'should accept extending collection as a parent' do
          Hydra::Works::AddCollectionToCollection.call( cullection1, collection1 )
          expect( Hydra::Works::GetCollectionsFromCollection.call( cullection1 ) ).to eq [collection1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @works_collection101  = Hydra::Works::Collection.new
        @generic_work101      = Hydra::Works::GenericWork::Base.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_PCDM_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child collections' do

        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::Generic(Work|File)::Base with ID:  was expected to works_collection\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `works_collection\?' for .*/ }

        it 'should NOT aggregate Hydra::Works::GenericWork in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @generic_work101 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericFile in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @generic_file101 ) }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @pcdm_collection101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @pcdm_object101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @pcdm_file101 ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @non_PCDM_object ) }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in collections aggregation' do
          expect{ Hydra::Works::AddCollectionToCollection.call( @works_collection101, @af_base_object ) }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end
end
