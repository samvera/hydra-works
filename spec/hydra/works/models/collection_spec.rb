require 'spec_helper'

describe Hydra::Works::Collection do
  subject { described_class.new }

  let(:collection1) { described_class.new }
  let(:collection2) { described_class.new }
  let(:collection3) { described_class.new }
  let(:collection4) { described_class.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work4) { Hydra::Works::GenericWork::Base.new }

  describe '#collections' do
    it 'returns empty array when only generic_works are aggregated' do
      subject.generic_works << generic_work1
      subject.generic_works << generic_work2
      expect(subject.collections).to eq []
    end

    context 'with other collections & generic_works' do
      before do
        subject.collections << collection1
        subject.collections << collection2
        subject.generic_works << generic_work1
        subject.generic_works << generic_work2
      end

      it 'returns only collections' do
        expect(subject.collections).to eq [collection1, collection2]
      end
    end
  end

  describe '#collections <<' do
    context 'with acceptable collections' do
      context 'with collections and generic_works' do
        before do
          subject.collections << collection1
          subject.collections << collection2
          subject.generic_works << generic_work1
          subject.generic_works << generic_work2
        end

        it 'adds an generic_work to collection with collections and generic_works' do
          subject.collections << collection3
          expect(subject.collections).to eq [collection1, collection2, collection3]
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

        it 'accepts implementing collection as a child' do
          subject.collections << kollection1
          expect(subject.collections).to eq [kollection1]
        end

        it 'accepts implementing collection as a parent' do
          subject.collections << collection1
          expect(subject.collections).to eq [collection1]
        end
      end

      describe 'aggregates collections that extend Hydra::Works' do
        before do
          class Cullection < Hydra::Works::Collection
          end
        end
        after { Object.send(:remove_const, :Cullection) }
        let(:cullection1) { Cullection.new }

        it 'accepts extending collection as a child' do
          subject.collections << cullection1
          expect(subject.collections).to eq [cullection1]
        end

        it 'accepts extending collection as a parent' do
          subject.collections << collection1
          expect(subject.collections).to eq [collection1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @works_collection101  = described_class.new
        @generic_work101      = Hydra::Works::GenericWork::Base.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_pcdm_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child collections' do
        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::Generic(Work|File)::Base with ID:  was expected to collection\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `collection\?' for .*/ }

        it 'does not aggregate Hydra::Works::GenericWork in collections aggregation' do
          expect { subject.collections << @generic_work101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::Works::GenericFile in collections aggregation' do
          expect { subject.collections << @generic_file101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::PCDM::Collections in collections aggregation' do
          expect { subject.collections << @pcdm_collection101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Objects in collections aggregation' do
          expect { subject.collections << @pcdm_object101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Files in collections aggregation' do
          expect { subject.collections << @pcdm_file101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate non-PCDM objects in collections aggregation' do
          expect { subject.collections << @non_pcdm_object }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate AF::Base objects in collections aggregation' do
          expect { subject.collections << @af_base_object }.to raise_error(error_type2, error_message2)
        end
      end
    end
  end

  describe 'collections.delete' do
    context 'when multiple collections' do
      before do
        subject.collections << collection1
        subject.collections << collection2
        subject.generic_works << generic_work2
        subject.collections << collection3
        subject.generic_works << generic_work1
        expect(subject.collections).to eq [collection1, collection2, collection3]
      end

      it 'removes first collection' do
        expect(subject.collections.delete collection1).to eq [collection1]
        expect(subject.collections).to eq [collection2, collection3]
        expect(subject.generic_works).to eq [generic_work2, generic_work1]
      end

      it 'removes last collection' do
        expect(subject.collections.delete collection3).to eq [collection3]
        expect(subject.collections).to eq [collection1, collection2]
        expect(subject.generic_works). to eq [generic_work2, generic_work1]
      end

      it 'removes middle collection' do
        expect(subject.collections.delete collection2).to eq [collection2]
        expect(subject.collections).to eq [collection1, collection3]
        expect(subject.generic_works). to eq [generic_work2, generic_work1]
      end
    end
  end

  describe '#generic_works' do
    it 'returns empty array when only collections are aggregated' do
      subject.collections << collection1
      subject.collections << collection2
      expect(subject.generic_works). to eq []
    end

    context 'with collections and generic works' do
      before do
        subject.collections << collection1
        subject.collections << collection2
        subject.generic_works << generic_work1
        subject.generic_works << generic_work2
      end

      it 'returns only generic works' do
        expect(subject.generic_works). to eq [generic_work1, generic_work2]
      end
    end
  end

  describe '#generic_works <<' do
    context 'with acceptable generic_works' do
      context 'with collections and generic_works' do
        before do
          subject.collections << collection1
          subject.collections << collection2
          subject.generic_works << generic_work1
          subject.generic_works << generic_work2
        end

        it 'adds generic_work to collection with collections and generic_works' do
          subject.generic_works << generic_work3
          expect(subject.generic_works).to eq [generic_work1, generic_work2, generic_work3]
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

        it 'accepts implementing generic_work as a child' do
          subject.generic_works << iwork1
          expect(subject.generic_works).to eq [iwork1]
        end
      end

      describe 'aggregates generic_works that extend Hydra::Works' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.new }

        it 'accepts extending generic_work as a child' do
          subject.generic_works << ework1
          expect(subject.generic_works).to eq [ework1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @works_collection101  = described_class.new
        @works_collection102  = described_class.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_pcdm_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic works' do
        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(GenericFile::Base|Collection) with ID:  was expected to generic_work\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `generic_work\?' for .*/ }

        it 'does not aggregate Hydra::Works::Collection in generic works aggregation' do
          expect { subject.generic_works << @works_collection101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::Works::GenericFile in generic works aggregation' do
          expect { subject.generic_works << @generic_file101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::PCDM::Collections in generic works aggregation' do
          expect { subject.generic_works << @pcdm_collection101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Objects in generic works aggregation' do
          expect { subject.generic_works << @pcdm_object101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Files in generic works aggregation' do
          expect { subject.generic_works << @pcdm_file101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate non-PCDM objects in generic works aggregation' do
          expect { subject.generic_works << @non_pcdm_object }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate AF::Base objects in generic works aggregation' do
          expect { subject.generic_works << @af_base_object }.to raise_error(error_type2, error_message2)
        end
      end
    end
  end

  describe '#generic_works.delete' do
    context 'when multiple generic works' do
      before do
        subject.generic_works << generic_work1
        subject.generic_works << generic_work2
        subject.collections << collection2
        subject.generic_works << generic_work3
        subject.collections << collection1
        expect(subject.generic_works). to eq [generic_work1, generic_work2, generic_work3]
      end

      it 'removes first generic work' do
        expect(subject.generic_works.delete generic_work1).to eq [generic_work1]
        expect(subject.generic_works). to eq [generic_work2, generic_work3]
        expect(subject.collections).to eq [collection2, collection1]
      end

      it 'removes last generic work' do
        expect(subject.generic_works.delete generic_work3).to eq [generic_work3]
        expect(subject.generic_works). to eq [generic_work1, generic_work2]
        expect(subject.collections).to eq [collection2, collection1]
      end

      it 'removes middle generic work' do
        expect(subject.generic_works.delete generic_work2).to eq [generic_work2]
        expect(subject.generic_works). to eq [generic_work1, generic_work3]
        expect(subject.collections).to eq [collection2, collection1]
      end
    end
  end

  describe '#related_objects' do
    let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }

    context 'with collections and generic works' do
      before do
        subject.collections << collection1
        subject.collections << collection2
        subject.generic_works << generic_work1
      end

      it 'returns empty array when only collections and generic works are aggregated' do
        expect(subject.related_objects).to eq []
      end

      it 'returns only related objects' do
        subject.related_objects << object2
        expect(subject.related_objects).to eq [object2]
      end

      it 'returns related objects of various types' do
        subject.related_objects << generic_work2
        subject.related_objects << generic_file1
        subject.related_objects << object1
        subject.save
        subject.reload
        expect(subject.related_objects.include? object1).to be true
        expect(subject.related_objects.include? generic_work2).to be true
        expect(subject.related_objects.include? generic_file1).to be true
        expect(subject.related_objects.size).to eq 3
      end
    end
  end

  describe '#related_objects <<' do
    context 'with acceptable related objects' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }
      let(:generic_file1) { Hydra::Works::GenericFile::Base.new }

      it 'adds various types of related objects to collection' do
        subject.related_objects << generic_work1
        subject.related_objects << generic_file1
        subject.related_objects << object1
        subject.save
        subject.reload
        expect(subject.related_objects.include? generic_work1).to be true
        expect(subject.related_objects.include? generic_file1).to be true
        expect(subject.related_objects.include? object1).to be true
        expect(subject.related_objects.size).to eq 3
      end

      context 'with collections and generic_works' do
        before do
          subject.collections << collection1
          subject.collections << collection2
          subject.generic_works << generic_work1
          subject.generic_works << generic_work2
          subject.related_objects << object1
        end

        it 'adds a related object to collection with collections and generic_works' do
          subject.related_objects << object2
          subject.save
          subject.reload
          expect(subject.related_objects.include? object1).to be true
          expect(subject.related_objects.include? object2).to be true
          expect(subject.related_objects.size).to eq 2
        end
      end
    end

    context 'with unacceptable child related objects' do
      let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.new }

      it 'does not aggregate Hydra::Works::Collection in related objects aggregation' do
        expect { subject.related_objects << collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::Works::Collection:.*> is not a PCDM object./)
      end

      it 'does not aggregate Hydra::PCDM::Collections in related objects aggregation' do
        expect { subject.related_objects << pcdm_collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::PCDM::Collection:.* is not a PCDM object./)
      end

      it 'does not aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect { subject.related_objects << pcdm_file1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got Hydra::PCDM::File.*/)
      end

      it 'does not aggregate non-PCDM objects in related objects aggregation' do
        expect { subject.related_objects << non_PCDM_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got String.*/)
      end

      it 'does not aggregate AF::Base objects in related objects aggregation' do
        expect { subject.related_objects << af_base_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* is not a PCDM object./)
      end
    end

    context 'with invalid behaviors' do
      let(:object1) { Hydra::PCDM::Object.new }
      let(:object2) { Hydra::PCDM::Object.new }

      it 'does not allow related objects to repeat' do
        skip 'skipping this test because issue pcdm#92 needs to be addressed' do
          subject.related_objects << object1
          subject.related_objects << object2
          subject.related_objects << object1
          related_objects = subject.related_objects
          expect(related_objects.include? object1).to be true
          expect(related_objects.include? object2).to be true
          expect(related_objects.size).to eq 2
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
        subject.collections << collection2
        subject.generic_works << generic_work1
        subject.related_objects << related_file3
        subject.related_objects << related_object4
        subject.collections << collection1
        subject.related_objects << related_work5
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4, related_work5]
      end

      it 'removes first related object' do
        expect(subject.related_objects.delete related_object1).to eq [related_object1]
        expect(subject.related_objects).to eq [related_work2, related_file3, related_object4, related_work5]
        expect(subject.collections).to eq [collection2, collection1]
        expect(subject.generic_works). to eq [generic_work1]
      end

      it 'removes last related object' do
        expect(subject.related_objects.delete related_work5).to eq [related_work5]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4]
        expect(subject.collections).to eq [collection2, collection1]
        expect(subject.generic_works). to eq [generic_work1]
      end

      it 'removes middle related object' do
        expect(subject.related_objects.delete related_file3).to eq [related_file3]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_object4, related_work5]
        expect(subject.collections).to eq [collection2, collection1]
        expect(subject.generic_works). to eq [generic_work1]
      end
    end
  end

  describe '#collections=' do
    it 'aggregates collections' do
      collection1.collections = [collection2, collection3]
      expect(collection1.collections).to eq [collection2, collection3]
    end
  end

  describe '#generic_works=' do
    it 'aggregates generic_works' do
      collection1.generic_works = [generic_work1, generic_work2]
      expect(collection1.generic_works).to eq [generic_work1, generic_work2]
    end
  end

  describe 'Related objects' do
    let(:object) { Hydra::PCDM::Object.new }
    let(:collection) { described_class.new }

    before do
      collection.related_objects = [object]
    end

    it 'persists' do
      expect(collection.related_objects).to eq [object]
    end
  end

  describe 'should have parent collection accessors' do
    before do
      collection1.collections << collection2
      collection1.save
    end

    it 'has parents' do
      expect(collection2.member_of).to eq [collection1]
    end
    it 'has a parent collection' do
      expect(collection2.in_collections).to eq [collection1]
    end
  end

  describe 'make sure deprecated methods still work' do
    it 'deprecated methods should pass' do
      expect(collection1.child_collections = [collection2]).to eq [collection2]
      expect(collection1.child_collections << collection3).to eq [collection2, collection3]
      expect(collection1.child_collections += [collection4]).to eq [collection2, collection3, collection4]
      expect(collection1.child_generic_works = [generic_work1]).to eq [generic_work1]
      expect(collection1.child_generic_works << generic_work2).to eq [generic_work1, generic_work2]
      expect(collection1.child_generic_works += [generic_work3]).to eq [generic_work1, generic_work2, generic_work3]
      collection1.save # required until issue AF-Agg-75 is fixed
      expect(collection2.parent_collections).to eq [collection1]
      expect(collection2.parents).to eq [collection1]
      expect(collection2.parent_collection_ids).to eq [collection1.id]
    end
  end
end
