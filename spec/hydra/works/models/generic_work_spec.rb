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

  describe '#works=' do
    it 'aggregates works' do
      generic_work1.works = [generic_work2, generic_work3]
      expect(generic_work1.works).to eq [generic_work2, generic_work3]
    end
  end

  describe '#file_sets=' do
    it 'aggregates file_sets' do
      generic_work1.file_sets = [file_set1, file_set2]
      expect(generic_work1.file_sets).to eq [file_set1, file_set2]
    end
  end

  describe '#file_set_ids' do
    it 'lists file_set ids' do
      generic_work1.file_sets = [file_set1, file_set2]
      expect(generic_work1.file_set_ids).to eq [file_set1.id, file_set2.id]
    end
  end

  context 'sub-class' do
    before do
      class TestWork < Hydra::Works::GenericWork
      end
    end

    subject { TestWork.new(file_sets: [file_set1]) }

    it 'has many generic files' do
      expect(subject.file_sets).to eq [file_set1]
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

  describe '#works' do
    context 'with acceptable works' do
      context 'with file_sets and works' do
        before do
          subject.file_sets << file_set1
          subject.file_sets << file_set2
          subject.works << generic_work1
          subject.works << generic_work2
        end

        it 'adds generic_work to generic_work with file_sets and works' do
          subject.works << generic_work3
          expect(subject.works).to eq [generic_work1, generic_work2, generic_work3]
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
          subject.works << iwork1
          expect(subject.works).to eq [iwork1]
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
          subject.works << ework1
          expect(subject.works).to eq [ework1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @generic_work102      = described_class.new

        @works_collection101  = Hydra::Works::Collection.new
        @file_set101 = Hydra::Works::FileSet.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_pcdm_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic works' do
        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(FileSet|Collection) with ID:  was expected to work\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `work\?' for .*/ }

        it 'does not aggregate Hydra::Works::Collection in generic works aggregation' do
          expect { subject.works << @works_collection101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::Works::FileSet in generic works aggregation' do
          expect { subject.works << @file_set101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::PCDM::Collections in generic works aggregation' do
          expect { subject.works << @pcdm_collection101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Objects in generic works aggregation' do
          expect { subject.works << @pcdm_object101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Files in generic works aggregation' do
          expect { subject.works << @pcdm_file101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate non-PCDM objects in generic works aggregation' do
          expect { subject.works << @non_pcdm_object }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate AF::Base objects in generic works aggregation' do
          expect { subject.works << @af_base_object }.to raise_error(error_type2, error_message2)
        end
      end
    end
  end

  describe '#file_sets <<' do
    it 'returns empty array when only file_sets are aggregated' do
      subject.file_sets << file_set1
      subject.file_sets << file_set2
      expect(subject.works).to eq []
    end

    context 'with file_sets and works' do
      before do
        subject.file_sets << file_set1
        subject.file_sets << file_set2
        subject.works << generic_work1
        subject.works << generic_work2
      end

      it 'returns only works' do
        expect(subject.works).to eq [generic_work1, generic_work2]
      end
    end
  end

  describe '#works.delete' do
    context 'when multiple collections' do
      before do
        subject.works << generic_work1
        subject.works << generic_work2
        subject.file_sets << file_set2
        subject.works << generic_work3
        subject.works << generic_work4
        subject.file_sets << file_set1
        subject.works << generic_work5
        expect(subject.works).to eq [generic_work1, generic_work2, generic_work3, generic_work4, generic_work5]
      end

      it 'removes first collection' do
        expect(subject.works.delete generic_work1).to eq [generic_work1]
        expect(subject.works).to eq [generic_work2, generic_work3, generic_work4, generic_work5]
        expect(subject.file_sets).to eq [file_set2, file_set1]
      end

      it 'removes last collection' do
        expect(subject.works.delete generic_work5).to eq [generic_work5]
        expect(subject.works).to eq [generic_work1, generic_work2, generic_work3, generic_work4]
        expect(subject.file_sets).to eq [file_set2, file_set1]
      end

      it 'removes middle collection' do
        expect(subject.works.delete generic_work3).to eq [generic_work3]
        expect(subject.works).to eq [generic_work1, generic_work2, generic_work4, generic_work5]
        expect(subject.file_sets).to eq [file_set2, file_set1]
      end
    end
  end

  describe '#works <<' do
    context 'with acceptable works' do
      context 'with file_sets and works' do
        let(:file_set3) { Hydra::Works::FileSet.new }
        before do
          subject.file_sets << file_set1
          subject.file_sets << file_set2
          subject.works << generic_work1
          subject.works << generic_work2
        end

        it 'adds file_set to generic_work with file_sets and works' do
          subject.file_sets << file_set3
          expect(subject.file_sets).to eq [file_set1, file_set2, file_set3]
        end
      end

      describe 'aggregates file_sets that implement Hydra::Works::FileSetBehavior' do
        before do
          class DummyIncFile < ActiveFedora::Base
            include Hydra::Works::FileSetBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncFile) }
        let(:ifile1) { DummyIncFile.new }

        it 'accepts implementing file_set as a child' do
          subject.file_sets << ifile1
          expect(subject.file_sets).to eq [ifile1]
        end
      end

      describe 'aggregates file_sets that extend Hydra::Works::FileSet' do
        before do
          class DummyExtFile < Hydra::Works::FileSet
          end
        end
        after { Object.send(:remove_const, :DummyExtFile) }
        let(:efile1) { DummyExtFile.new }

        it 'accepts extending file_set as a child' do
          subject.file_sets << efile1
          expect(subject.file_sets).to eq [efile1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @generic_work102      = described_class.new

        @works_collection101  = Hydra::Works::Collection.new
        @generic_work101      = described_class.new
        @file_set101 = Hydra::Works::FileSet.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_pcdm_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic files' do
        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(GenericWork|Collection) with ID:  was expected to file_set\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `file_set\?' for .*/ }

        it 'does not aggregate Hydra::Works::Collection in generic files aggregation' do
          expect { subject.file_sets << @works_collection101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::Works::GenericWork in generic files aggregation' do
          expect { subject.file_sets << @generic_work101 }.to raise_error(error_type1, error_message1)
        end

        it 'does not aggregate Hydra::PCDM::Collections in generic files aggregation' do
          expect { subject.file_sets << @pcdm_collection101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Objects in generic files aggregation' do
          expect { subject.file_sets << @pcdm_object101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate Hydra::PCDM::Files in generic files aggregation' do
          expect { subject.file_sets << @pcdm_file101 }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate non-PCDM objects in generic files aggregation' do
          expect { subject.file_sets << @non_pcdm_object }.to raise_error(error_type2, error_message2)
        end

        it 'does not aggregate AF::Base objects in generic files aggregation' do
          expect { subject.file_sets << @af_base_object }.to raise_error(error_type2, error_message2)
        end
      end
    end
  end

  context 'move generic file' do
    before do
      subject.file_sets << file_set1
      subject.file_sets << file_set2
    end
    it 'moves file from one work to another' do
      expect(subject.file_sets).to eq([file_set1, file_set2])
      expect(generic_work1.file_sets).to eq([])
      generic_work1.file_sets << subject.file_sets.delete(file_set1)
      expect(subject.file_sets).to eq([file_set2])
      expect(generic_work1.file_sets).to eq([file_set1])
    end
  end

  describe '#file_sets' do
    it 'returns empty array when only works are aggregated' do
      subject.works << generic_work1
      subject.works << generic_work2
      expect(subject.file_sets).to eq []
    end

    context 'with file_sets and works' do
      before do
        subject.file_sets << file_set1
        subject.file_sets << file_set2
        subject.works << generic_work1
        subject.works << generic_work2
      end

      it 'returns only file_sets' do
        expect(subject.file_sets).to eq [file_set1, file_set2]
      end
    end
  end

  describe '#file_sets.delete' do
    context 'when multiple collections' do
      let(:file_set3) { Hydra::Works::FileSet.new }
      let(:file_set4) { Hydra::Works::FileSet.new }
      let(:file_set5) { Hydra::Works::FileSet.new }
      before do
        subject.file_sets << file_set1
        subject.file_sets << file_set2
        subject.works << generic_work2
        subject.file_sets << file_set3
        subject.file_sets << file_set4
        subject.works << generic_work1
        subject.file_sets << file_set5
        expect(subject.file_sets).to eq [file_set1, file_set2, file_set3, file_set4, file_set5]
      end

      it 'removes first collection' do
        expect(subject.file_sets.delete file_set1).to eq [file_set1]
        expect(subject.file_sets).to eq [file_set2, file_set3, file_set4, file_set5]
        expect(subject.works).to eq [generic_work2, generic_work1]
      end

      it 'removes last collection' do
        expect(subject.file_sets.delete file_set5).to eq [file_set5]
        expect(subject.file_sets).to eq [file_set1, file_set2, file_set3, file_set4]
        expect(subject.works).to eq [generic_work2, generic_work1]
      end

      it 'removes middle collection' do
        expect(subject.file_sets.delete file_set3).to eq [file_set3]
        expect(subject.file_sets).to eq [file_set1, file_set2, file_set4, file_set5]
        expect(subject.works).to eq [generic_work2, generic_work1]
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
          subject.file_sets << file_set1
          subject.file_sets << file_set2
          subject.works << generic_work1
          subject.works << generic_work2
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
        subject.works << generic_work1
        subject.works << generic_work1
        subject.file_sets << file_set1
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
        subject.works << generic_work2
        subject.file_sets << file_set1
        subject.related_objects << related_file3
        subject.related_objects << related_object4
        subject.works << generic_work1
        subject.related_objects << related_work5
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4, related_work5]
      end

      it 'removes first related object' do
        expect(subject.related_objects.delete related_object1).to eq [related_object1]
        expect(subject.related_objects).to eq [related_work2, related_file3, related_object4, related_work5]
        expect(subject.works).to eq [generic_work2, generic_work1]
        expect(subject.file_sets).to eq [file_set1]
      end

      it 'removes last related object' do
        expect(subject.related_objects.delete related_work5).to eq [related_work5]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_file3, related_object4]
        expect(subject.works).to eq [generic_work2, generic_work1]
        expect(subject.file_sets).to eq [file_set1]
      end

      it 'removes middle related object' do
        expect(subject.related_objects.delete related_file3).to eq [related_file3]
        expect(subject.related_objects).to eq [related_object1, related_work2, related_object4, related_work5]
        expect(subject.works).to eq [generic_work2, generic_work1]
        expect(subject.file_sets).to eq [file_set1]
      end
    end
  end

  describe 'should have parent work and collection accessors' do
    let(:collection1) { Hydra::Works::Collection.new }
    before do
      collection1.works << generic_work2
      generic_work1.works << generic_work2
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

  describe 'make sure deprecated methods still work' do
    it 'deprecated methods should pass' do
      Deprecation.silence(Hydra::Works::WorkBehavior) do
        expect(generic_work1.child_generic_works = [generic_work2]).to eq [generic_work2]
        expect(generic_work1.child_generic_works << generic_work3).to eq [generic_work2, generic_work3]
        expect(generic_work1.child_generic_works += [generic_work4]).to eq [generic_work2, generic_work3, generic_work4]
        generic_work1.save # required until issue AF-Agg-75 is fixed
        expect(generic_work2.parent_generic_works).to eq [generic_work1]
        expect(generic_work2.parents).to eq [generic_work1]
      end
    end
  end
end
