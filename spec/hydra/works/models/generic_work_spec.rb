require 'spec_helper'

describe Hydra::Works::GenericWork do
  subject { described_class.new }

  let(:generic_work1) { described_class.new }
  let(:generic_work2) { described_class.new }
  let(:generic_work3) { described_class.new }
  let(:generic_work4) { described_class.new }
  let(:generic_work5) { described_class.new }

  let(:file_set1) { Hydra::Works::FileSet.new }
  let(:file_set2) { Hydra::Works::FileSet.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  let(:pcdm_file1) { Hydra::PCDM::File.new }

  describe "#file_set_ids" do
    it "returns non-ordered file set IDs" do
      generic_work1.members << file_set1
      generic_work1.ordered_members << file_set2

      expect(generic_work1.file_set_ids).to eq [file_set1.id, file_set2.id]
      expect(generic_work1.ordered_file_set_ids).to eq [file_set2.id]
    end
  end

  describe "#file_sets" do
    it "returns non-ordered file sets" do
      generic_work1.members << file_set1
      generic_work1.ordered_members << file_set2

      expect(generic_work1.file_sets).to eq [file_set1, file_set2]
    end
  end

  describe "#work_ids" do
    it "returns non-ordered file set IDs" do
      generic_work1.members << generic_work2
      generic_work1.ordered_members << generic_work3

      expect(generic_work1.work_ids).to eq [generic_work2.id, generic_work3.id]
      expect(generic_work1.ordered_work_ids).to eq [generic_work3.id]
    end
  end

  describe "#works" do
    it "returns non-ordered file sets" do
      generic_work1.members << generic_work2
      generic_work1.ordered_members << generic_work3

      expect(generic_work1.works).to eq [generic_work2, generic_work3]
    end
  end

  describe '#ordered_file_set_ids' do
    it 'lists file_set ids' do
      generic_work1.ordered_members = [file_set1, file_set2]
      expect(generic_work1.ordered_file_set_ids).to eq [file_set1.id, file_set2.id]
    end
  end

  context 'sub-class' do
    before do
      class TestWork < Hydra::Works::GenericWork
      end
    end

    subject { TestWork.new(ordered_members: [file_set1]) }

    it 'has many generic files' do
      expect(subject.ordered_file_sets).to eq [file_set1]
    end
  end

  describe 'Related objects' do
    let(:generic_work1) { described_class.new }
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      generic_work1.related_objects = [object1]
    end

    it 'persists' do
      expect(generic_work1.related_objects).to eq [object1]
    end
  end

  describe '#ordered_works' do
    context 'with acceptable works' do
      context 'with file_sets and works' do
        before do
          subject.ordered_members << file_set1
          subject.ordered_members << file_set2
          subject.ordered_members << generic_work1
          subject.ordered_members << generic_work2
        end

        it 'adds generic_work to generic_work with file_sets and works' do
          subject.ordered_members << generic_work3
          expect(subject.ordered_works).to eq [generic_work1, generic_work2, generic_work3]
        end
      end

      describe 'aggregates works that implement Hydra::Works::WorkBehavior' do
        before do
          class DummyIncWork < ActiveFedora::Base
            include Hydra::Works::WorkBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncWork) }
        let(:iwork1) { DummyIncWork.new }

        it 'accepts implementing generic_work as a child' do
          subject.ordered_members << iwork1
          expect(subject.ordered_works).to eq [iwork1]
        end
      end

      describe 'aggregates works that extend Hydra::Works::GenericWork' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.new }

        it 'accepts extending generic_work as a child' do
          subject.ordered_members << ework1
          expect(subject.ordered_works).to eq [ework1]
        end
      end
    end
  end

  context 'move generic file' do
    before do
      subject.ordered_members << file_set1
      subject.ordered_members << file_set2
    end
    it 'moves file from one work to another' do
      expect(subject.ordered_file_sets).to eq([file_set1, file_set2])
      expect(generic_work1.ordered_file_sets).to eq([])
      subject.ordered_member_proxies.delete_at(0)
      generic_work1.ordered_members << file_set1
      expect(subject.ordered_file_sets).to eq([file_set2])
      expect(generic_work1.ordered_file_sets).to eq([file_set1])
    end
  end

  describe '#file_sets' do
    it 'returns empty array when only works are aggregated' do
      subject.ordered_members << generic_work1
      subject.ordered_members << generic_work2
      expect(subject.ordered_file_sets).to eq []
    end

    context 'with file_sets and works' do
      before do
        subject.ordered_members << file_set1
        subject.ordered_members << file_set2
        subject.ordered_members << generic_work1
        subject.ordered_members << generic_work2
      end

      it 'returns only file_sets' do
        expect(subject.ordered_file_sets).to eq [file_set1, file_set2]
      end
    end
  end

  describe '#file_sets.delete' do
    context 'when multiple collections' do
      let(:file_set3) { Hydra::Works::FileSet.new }
      let(:file_set4) { Hydra::Works::FileSet.new }
      let(:file_set5) { Hydra::Works::FileSet.new }
      before do
        subject.ordered_members << file_set1
        subject.ordered_members << file_set2
        subject.ordered_members << generic_work2
        subject.ordered_members << file_set3
        subject.ordered_members << file_set4
        subject.ordered_members << generic_work1
        subject.ordered_members << file_set5
        expect(subject.ordered_file_sets).to eq [file_set1, file_set2, file_set3, file_set4, file_set5]
      end

      it 'removes first collection' do
        subject.ordered_member_proxies.delete_at(0)
        expect(subject.ordered_file_sets).to eq [file_set2, file_set3, file_set4, file_set5]
        expect(subject.ordered_works).to eq [generic_work2, generic_work1]
      end

      it 'removes last collection' do
        subject.ordered_member_proxies.delete_at(6)
        expect(subject.ordered_file_sets).to eq [file_set1, file_set2, file_set3, file_set4]
        expect(subject.ordered_works).to eq [generic_work2, generic_work1]
      end

      it 'removes middle collection' do
        subject.ordered_member_proxies.delete_at(3)
        expect(subject.ordered_file_sets).to eq [file_set1, file_set2, file_set4, file_set5]
        expect(subject.ordered_works).to eq [generic_work2, generic_work1]
      end
    end
  end

  describe '#related_objects' do
    context 'with acceptable related objects' do
      it 'adds various types of related objects to generic_work' do
        subject.related_objects << generic_work1
        subject.related_objects << file_set1
        subject.related_objects << object1
        subject.save
        subject.reload
        expect(subject.related_objects.include? generic_work1).to be true
        expect(subject.related_objects.include? file_set1).to be true
        expect(subject.related_objects.include? object1).to be true
        expect(subject.related_objects.size).to eq 3
      end

      context 'with works and file_sets' do
        before do
          subject.ordered_file_sets << file_set1
          subject.ordered_file_sets << file_set2
          subject.ordered_works << generic_work1
          subject.ordered_works << generic_work2
          subject.related_objects << object1
        end

        it 'adds a related object to file_set with works and file_sets' do
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
      let(:collection1)      { Hydra::Works::Collection.new }
      let(:pcdm_collection1) { Hydra::PCDM::Collection.new }
      let(:pcdm_file1)       { Hydra::PCDM::File.new }
      let(:non_PCDM_object)  { "I'm not a PCDM object" }
      let(:af_base_object)   { ActiveFedora::Base.new }

      let(:error_message) { 'child_related_object must be a pcdm object' }

      it 'does not aggregate Hydra::Works::Collection in related objects aggregation' do
        expect { subject.related_objects << collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::Works::Collection:.*> is not a PCDM object./)
      end

      it 'does not aggregate Hydra::PCDM::Collections in related objects aggregation' do
        expect { subject.related_objects << pcdm_collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::PCDM::Collection:.*> is not a PCDM object./)
      end

      it 'does not aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect { subject.related_objects << pcdm_file1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got Hydra::PCDM::File.*/)
      end

      it 'does not aggregate non-PCDM objects in related objects aggregation' do
        expect { subject.related_objects << non_PCDM_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got String.*/)
      end

      it 'does not aggregate AF::Base objects in related objects aggregation' do
        expect { subject.related_objects << af_base_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base:.*> is not a PCDM object./)
      end
    end

    context 'with invalid bahaviors' do
      it 'does not allow related objects to repeat' do
        skip 'skipping this test because issue pcdm#92 needs to be addressed' do
          subject.related_objects << object1
          subject.related_objects << object2
          subject.related_objects << object1
          expect(subject.related_objects.include? object1).to be true
          expect(subject.related_objects.include? object2).to be true
          expect(subject.related_objects.size).to eq 2
        end
      end
    end
  end

  describe '#related_objects <<' do
    context 'with file sets and works' do
      before do
        subject.ordered_members << generic_work1
        subject.ordered_members << generic_work1
        subject.ordered_members << file_set1
      end

      it 'returns empty array when only generic files and generic works are aggregated' do
        expect(subject.related_objects).to eq []
      end

      it 'returns only related objects' do
        subject.related_objects << object2
        expect(subject.related_objects).to eq [object2]
      end

      it 'returns related objects of various types' do
        subject.related_objects << generic_work2
        subject.related_objects << file_set1
        subject.related_objects << object1
        expect(subject.related_objects).to eq [generic_work2, file_set1, object1]
        expect(subject.related_objects.size).to eq 3
      end
    end
  end

  describe '#related_objects.delete' do
    context 'when multiple related objects' do
      let(:related_object1) { Hydra::PCDM::Object.new }
      let(:related_work2) { described_class.new }
      let(:related_file3) { Hydra::Works::FileSet.new }
      let(:related_object4) { Hydra::PCDM::Object.new }
      let(:related_work5) { described_class.new }
      before do
        subject.related_objects << related_object1
        subject.related_objects << related_work2
        subject.ordered_members << generic_work2
        subject.ordered_members << file_set1
        subject.related_objects << related_file3
        subject.related_objects << related_object4
        subject.ordered_members << generic_work1
        subject.related_objects << related_work5
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4, related_work5]
      end

      it 'removes first related object' do
        expect(subject.related_objects.delete related_object1).to eq [related_object1]
        expect(subject.related_objects).to eq [related_work2, related_file3, related_object4, related_work5]
        expect(subject.ordered_works).to eq [generic_work2, generic_work1]
        expect(subject.ordered_file_sets).to eq [file_set1]
      end

      it 'removes last related object' do
        expect(subject.related_objects.delete related_work5).to eq [related_work5]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4]
        expect(subject.ordered_works).to eq [generic_work2, generic_work1]
        expect(subject.ordered_file_sets).to eq [file_set1]
      end

      it 'removes middle related object' do
        expect(subject.related_objects.delete related_file3).to eq [related_file3]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_object4, related_work5]
        expect(subject.ordered_works).to eq [generic_work2, generic_work1]
        expect(subject.ordered_file_sets).to eq [file_set1]
      end
    end
  end

  describe 'should have parent work and collection accessors' do
    let(:collection1) { Hydra::Works::Collection.new }
    before do
      collection1.ordered_members << generic_work2
      generic_work1.ordered_members << generic_work2
      collection1.save
      generic_work1.save
      generic_work2.save
    end

    it 'has parents' do
      expect(generic_work2.member_of).to eq [collection1, generic_work1]
    end
    it 'has a parent collection' do
      expect(generic_work2.in_collections).to eq [collection1]
    end
    it 'has a parent generic_work' do
      expect(generic_work2.in_works).to eq [generic_work1]
    end
  end
end
