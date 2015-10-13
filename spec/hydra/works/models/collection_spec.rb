require 'spec_helper'

describe Hydra::Works::Collection do
  subject { described_class.new }

  let(:collection1) { described_class.new }
  let(:collection2) { described_class.new }
  let(:collection3) { described_class.new }
  let(:collection4) { described_class.new }

  let(:generic_work1) { Hydra::Works::GenericWork.new }
  let(:generic_work2) { Hydra::Works::GenericWork.new }
  let(:generic_work3) { Hydra::Works::GenericWork.new }
  let(:generic_work4) { Hydra::Works::GenericWork.new }

  describe '#collections' do
    it 'returns empty array when only works are aggregated' do
      subject.members << generic_work1
      subject.members << generic_work2
      expect(subject.collections).to eq []
    end

    context 'with other collections & works' do
      before do
        subject.members << collection1
        subject.members << collection2
        subject.members << generic_work1
        subject.members << generic_work2
      end

      it 'returns only collections' do
        expect(subject.collections).to eq [collection1, collection2]
      end
    end
  end

  describe '#works' do
    it 'returns empty array when only collections are aggregated' do
      subject.members << collection1
      subject.members << collection2
      expect(subject.works). to eq []
    end

    context 'with collections and generic works' do
      before do
        subject.members << collection1
        subject.members << collection2
        subject.members << generic_work1
        subject.members << generic_work2
      end

      it 'returns only generic works' do
        expect(subject.works). to eq [generic_work1, generic_work2]
      end
    end
  end

  describe '#related_objects' do
    let(:generic_file1) { Hydra::Works::FileSet.new }
    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }

    context 'with collections and generic works' do
      before do
        subject.members << collection1
        subject.members << collection2
        subject.members << generic_work1
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
      let(:generic_file1) { Hydra::Works::FileSet.new }

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

      context 'with collections and works' do
        before do
          subject.collections << collection1
          subject.collections << collection2
          subject.works << generic_work1
          subject.works << generic_work2
          subject.related_objects << object1
        end

        it 'adds a related object to collection with collections and works' do
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
    let(:related_work2)   { Hydra::Works::GenericWork.new }
    let(:related_file3)   { Hydra::Works::FileSet.new }
    let(:related_object4) { Hydra::PCDM::Object.new }
    let(:related_work5)   { Hydra::Works::GenericWork.new }

    context 'when multiple related objects' do
      before do
        subject.related_objects << related_object1
        subject.related_objects << related_work2
        subject.members << collection2
        subject.members << generic_work1
        subject.related_objects << related_file3
        subject.related_objects << related_object4
        subject.members << collection1
        subject.related_objects << related_work5
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4, related_work5]
      end

      it 'removes first related object' do
        expect(subject.related_objects.delete related_object1).to eq [related_object1]
        expect(subject.related_objects).to eq [related_work2, related_file3, related_object4, related_work5]
        expect(subject.collections).to eq [collection2, collection1]
        expect(subject.works). to eq [generic_work1]
      end

      it 'removes last related object' do
        expect(subject.related_objects.delete related_work5).to eq [related_work5]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4]
        expect(subject.collections).to eq [collection2, collection1]
        expect(subject.works). to eq [generic_work1]
      end

      it 'removes middle related object' do
        expect(subject.related_objects.delete related_file3).to eq [related_file3]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_object4, related_work5]
        expect(subject.collections).to eq [collection2, collection1]
        expect(subject.works). to eq [generic_work1]
      end
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
      collection1.members << collection2
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
      Deprecation.silence(Hydra::Works::CollectionBehavior) do
        collection1.members << collection2
        collection1.members << generic_work1
        expect(collection1.child_collections).to eq [collection2]
        expect(collection1.child_collection_ids).to eq [collection2.id]
        expect(collection1.child_generic_works).to eq [generic_work1]
        expect(collection1.child_generic_work_ids).to eq [generic_work1.id]
        collection1.save # required until issue AF-Agg-75 is fixed
        expect(collection2.parent_collections).to eq [collection1]
        expect(collection2.parents).to eq [collection1]
      end
    end
  end
end
