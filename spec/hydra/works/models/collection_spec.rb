require 'spec_helper'

describe Hydra::Works::Collection do

  subject { Hydra::Works::Collection.new }

  let(:collection1) { Hydra::Works::Collection.new }
  let(:collection2) { Hydra::Works::Collection.new }
  let(:collection3) { Hydra::Works::Collection.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }

  describe '#child_collections' do
    it 'should return empty array when only generic_works are aggregated' do
      subject.child_generic_works << generic_work1
      subject.child_generic_works << generic_work2
      expect(subject.child_collections ).to eq []
    end

    context 'with other collections & generic_works' do 
      before do 
        subject.child_collections << collection1
        subject.child_collections << collection2
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work2
      end

      it 'should only return collections' do
        expect(subject.child_collections ).to eq [collection1,collection2]
      end
    end  
  end

  describe '#child_collections <<' do
    context 'with acceptable collections' do
      context 'with collections and generic_works' do
        before do
          subject.child_collections << collection1
          subject.child_collections << collection2
          subject.child_generic_works << generic_work1
          subject.child_generic_works << generic_work2
        end

        it 'should add an generic_work to collection with collections and generic_works' do
          subject.child_collections << collection3
          expect( subject.child_collections ).to eq [collection1,collection2,collection3]
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
          subject.child_collections << kollection1
          expect( subject.child_collections ).to eq [kollection1]
        end

        it 'should accept implementing collection as a parent' do
          subject.child_collections << collection1
          expect( subject.child_collections ).to eq [collection1]
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
          subject.child_collections << cullection1
          expect( subject.child_collections ).to eq [cullection1]
        end

        it 'should accept extending collection as a parent' do
          subject.child_collections << collection1
          expect( subject.child_collections ).to eq [collection1]
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
          expect{ subject.child_collections << @generic_work101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericFile in collections aggregation' do
          expect{ subject.child_collections << @generic_file101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in collections aggregation' do
          expect{ subject.child_collections << @pcdm_collection101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
          expect{ subject.child_collections << @pcdm_object101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in collections aggregation' do
          expect{ subject.child_collections << @pcdm_file101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in collections aggregation' do
          expect{ subject.child_collections << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in collections aggregation' do
          expect{ subject.child_collections << @af_base_object }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end

  describe 'child_collections.delete' do
    context 'when multiple collections' do
      before do
        subject.child_collections << collection1
        subject.child_collections << collection2
        subject.child_generic_works << generic_work2
        subject.child_collections << collection3
        subject.child_generic_works << generic_work1
        expect( subject.child_collections ).to eq [collection1,collection2,collection3]
      end
      
      it 'should remove first collection' do
        expect( subject.child_collections.delete collection1 ).to eq [collection1]
        expect( subject.child_collections ).to eq [collection2,collection3]
        expect( subject.child_generic_works ).to eq [generic_work2,generic_work1]    
      end
        
      it 'should remove last collection' do
        expect( subject.child_collections.delete collection3 ).to eq [collection3]
        expect( subject.child_collections ).to eq [collection1,collection2]
        expect( subject.child_generic_works). to eq [generic_work2,generic_work1]      
      end
   
      it 'should remove middle collection' do
        expect( subject.child_collections.delete collection2 ).to eq [collection2]
        expect( subject.child_collections ).to eq [collection1,collection3]
        expect( subject.child_generic_works). to eq [generic_work2,generic_work1]    
      end
    end 
  end   

  describe '#child_generic_works' do
    it 'should return empty array when only collections are aggregated' do
      subject.child_collections << collection1
      subject.child_collections << collection2
      expect(subject.child_generic_works). to eq []
    end

    context 'with collections and generic works' do
      before do 
        subject.child_collections << collection1
        subject.child_collections << collection2
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work2
      end

      it 'should only return generic works' do
        expect(subject.child_generic_works). to eq [generic_work1,generic_work2]     
      end
    end
  end 

  describe '#child_generic_works <<' do
    
    context 'with acceptable generic_works' do
      context 'with collections and generic_works' do
        before do
          subject.child_collections << collection1
          subject.child_collections << collection2
          subject.child_generic_works << generic_work1
          subject.child_generic_works << generic_work2
        end

        it 'should add generic_work to collection with collections and generic_works' do 
          subject.child_generic_works << generic_work3
          expect( subject.child_generic_works  ).to eq [generic_work1,generic_work2,generic_work3]
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
        let(:iwork1) { DummyIncWork.new }
        
        it 'should accept implementing generic_work as a child' do
          subject.child_generic_works << iwork1
          expect( subject.child_generic_works  ).to eq [iwork1]
        end
      end 

      describe 'aggregates generic_works that extend Hydra::Works' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.new }

        it 'should accept extending generic_work as a child' do
          subject.child_generic_works << ework1
          expect( subject.child_generic_works  ).to eq [ework1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @works_collection101  = Hydra::Works::Collection.new
        @works_collection102  = Hydra::Works::Collection.new
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
          expect{ subject.child_generic_works << @works_collection101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericFile in generic works aggregation' do
          expect{ subject.child_generic_works << @generic_file101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in generic works aggregation' do
          expect{ subject.child_generic_works << @pcdm_collection101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in generic works aggregation' do
          expect{ subject.child_generic_works << @pcdm_object101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in generic works aggregation' do
          expect{ subject.child_generic_works << @pcdm_file101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in generic works aggregation' do
          expect{ subject.child_generic_works << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in generic works aggregation' do
          expect{ subject.child_generic_works << @af_base_object }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end

  describe '#child_generic_works.delete' do
    context 'when multiple generic works' do
      before do
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work2
        subject.child_collections << collection2
        subject.child_generic_works << generic_work3
        subject.child_collections << collection1
        expect( subject.child_generic_works). to eq [generic_work1,generic_work2,generic_work3]
      end
      
      it 'should remove first generic work' do
        expect( subject.child_generic_works.delete generic_work1 ).to eq [generic_work1]
        expect( subject.child_generic_works). to eq [generic_work2,generic_work3]
        expect( subject.child_collections ).to eq [collection2,collection1]
      end
        
      it 'should remove last generic work' do
        expect( subject.child_generic_works.delete generic_work3 ).to eq [generic_work3]
        expect( subject.child_generic_works). to eq [generic_work1,generic_work2]
        expect( subject.child_collections ).to eq [collection2,collection1]
      end
   
      it 'should remove middle generic work' do
        expect( subject.child_generic_works.delete generic_work2 ).to eq [generic_work2]
        expect( subject.child_generic_works). to eq [generic_work1,generic_work3]
        expect( subject.child_collections ).to eq [collection2,collection1]
      end
    end 
  end   

  describe '#related_objects' do
    let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }

    context 'with collections and generic works' do
      before do
        subject.child_collections << collection1
        subject.child_collections << collection2
        subject.child_generic_works << generic_work1
      end
        
      it 'should return empty array when only collections and generic works are aggregated' do
        expect(subject.related_objects ).to eq []
      end
      
      it 'should only return related objects' do
        subject.related_objects << object2
        expect(subject.related_objects ).to eq [object2]
      end
  
      it 'should return related objects of various types' do
        subject.related_objects << generic_work2
        subject.related_objects << generic_file1
        subject.related_objects << object1
        subject.save
        subject.reload
        expect( subject.related_objects.include? object1 ).to be true
        expect( subject.related_objects.include? generic_work2 ).to be true
        expect( subject.related_objects.include? generic_file1 ).to be true
        expect( subject.related_objects.size ).to eq 3
      end
    end
  end

  describe '#related_objects <<' do

    context 'with acceptable related objects' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:generic_file1) { Hydra::Works::GenericFile::Base.new }

      it 'should add various types of related objects to collection' do
        subject.related_objects << generic_work1
        subject.related_objects << generic_file1
        subject.related_objects << object1
        subject.save
        subject.reload
        expect( subject.related_objects.include? generic_work1 ).to be true
        expect( subject.related_objects.include? generic_file1 ).to be true
        expect( subject.related_objects.include? object1 ).to be true
        expect( subject.related_objects.size ).to eq 3
      end

      context 'with collections and generic_works' do
        before do
          subject.child_collections << collection1
          subject.child_collections << collection2
          subject.child_generic_works << generic_work1
          subject.child_generic_works << generic_work2
          subject.related_objects << object1
        end

        it 'should add a related object to collection with collections and generic_works' do
          subject.related_objects << object2
          subject.save
          subject.reload
          expect( subject.related_objects.include? object1 ).to be true
          expect( subject.related_objects.include? object2 ).to be true
          expect( subject.related_objects.size ).to eq 2
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(collection2.id,collection1.id,object1.id,object2.id)
          expect(subject.to_solr["collections_ssim"]).to include(collection2.id,collection1.id)
          expect(subject.to_solr["collections_ssim"]).not_to include(object1.id,object2.id,generic_work1.id,generic_work2.id)
          expect(subject.to_solr["related_objects_ssim"]).to include(object1.id,object2.id)
          expect(subject.to_solr["related_objects_ssim"]).not_to include(collection2.id,collection1.id,generic_work1.id,generic_work2.id)
        end
        end
      end
    end

    context 'with unacceptable child related objects' do
      let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.new }

      it 'should NOT aggregate Hydra::Works::Collection in related objects aggregation' do
        expect{ subject.related_objects << collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::Works::Collection:.*> is not a PCDM object./)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in related objects aggregation' do
        expect{ subject.related_objects << pcdm_collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::PCDM::Collection:.* is not a PCDM object./)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect{ subject.related_objects << pcdm_file1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got Hydra::PCDM::File.*/)
      end

      it 'should NOT aggregate non-PCDM objects in related objects aggregation' do
        expect{ subject.related_objects << non_PCDM_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got String.*/)
      end

      it 'should NOT aggregate AF::Base objects in related objects aggregation' do
        expect{ subject.related_objects << af_base_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* is not a PCDM object./)
      end
    end

    context 'with invalid behaviors' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }

      it 'should NOT allow related objects to repeat' do
        skip 'skipping this test because issue pcdm#92 needs to be addressed' do
        subject.related_objects << object1
        subject.related_objects << object2
        subject.related_objects << object1
        related_objects = subject.related_objects
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? object2 ).to be true
        expect( related_objects.size ).to eq 2
      end
      end
    end
  end

  describe '#related_objects.delete' do
    let(:related_object1) { Hydra::PCDM::Object.new }
    let(:related_work2)   { Hydra::Works::GenericWork::Base.new }
    let(:related_file3)   { Hydra::Works::GenericFile::Base.new }
    let(:related_object4) { Hydra::PCDM::Object.new }
    let(:related_work5)   { Hydra::Works::GenericWork::Base.new }

    context 'when multiple related objects' do
      before do
        subject.related_objects << related_object1
        subject.related_objects << related_work2
        subject.child_collections << collection2
        subject.child_generic_works << generic_work1
        subject.related_objects << related_file3
        subject.related_objects << related_object4
        subject.child_collections << collection1
        subject.related_objects << related_work5
        expect( subject.related_objects ).to eq [related_object1,related_work2,related_file3,related_object4,related_work5]
      end
        
      it 'should remove first related object' do
        expect( subject.related_objects.delete related_object1 ).to eq [related_object1]
        expect( subject.related_objects ).to eq [related_work2,related_file3,related_object4,related_work5]
        expect( subject.child_collections ).to eq [collection2,collection1]
        expect( subject.child_generic_works). to eq [generic_work1]
      end

      it 'should remove last related object' do
        expect( subject.related_objects.delete related_work5 ).to eq [related_work5]
        expect( subject.related_objects ).to eq [related_object1,related_work2,related_file3,related_object4]
        expect( subject.child_collections ).to eq [collection2,collection1]
        expect( subject.child_generic_works). to eq [generic_work1]
      end
        
      it 'should remove middle related object' do
        expect( subject.related_objects.delete related_file3 ).to eq [related_file3]
        expect( subject.related_objects ).to eq [related_object1,related_work2,related_object4,related_work5]
        expect( subject.child_collections ).to eq [collection2,collection1]
        expect( subject.child_generic_works). to eq [generic_work1]
      end
    end 
  end   

  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.child_collections = [collection2, collection3]
      expect(collection1.child_collections).to eq [collection2, collection3]
    end
  end

  describe '#child_generic_works=' do
    it 'should aggregate generic_works' do
      collection1.child_generic_works = [generic_work1,generic_work2]
      expect(collection1.child_generic_works).to eq [generic_work1,generic_work2]
    end
  end

  describe 'Related objects' do
    let(:object) { Hydra::PCDM::Object.new }
    let(:collection) { Hydra::Works::Collection.new }

    before do
      collection.related_objects = [object]
    end

    it 'persists' do
      expect(collection.related_objects).to eq [object]
    end
  end
end
