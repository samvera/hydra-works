require 'spec_helper'

describe Hydra::Works::Work do
  subject { described_class.new }

  let(:work1) { described_class.new }
  let(:work2) { described_class.new }
  let(:work3) { described_class.new }
  let(:work4) { described_class.new }
  let(:work5) { described_class.new }

  let(:file_set1) { Hydra::Works::FileSet.new }
  let(:file_set2) { Hydra::Works::FileSet.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  let(:pcdm_file1) { Hydra::PCDM::File.new }

  describe "#file_set_ids" do
    it "returns non-ordered file set IDs" do
      work1.members << file_set1
      work1.ordered_members << file_set2

      expect(work1.file_set_ids).to eq [file_set1.id, file_set2.id]
      Deprecation.silence Hydra::Works::WorkBehavior do
        expect(work1.ordered_file_set_ids).to eq [file_set2.id]
      end
    end
  end

  describe "#file_sets" do
    it "returns non-ordered file sets" do
      work1.members << file_set1
      work1.ordered_members << file_set2

      expect(work1.file_sets).to eq [file_set1, file_set2]
    end
  end

  describe "#work_ids" do
    it "returns non-ordered file set IDs" do
      work1.members << work2
      work1.ordered_members << work3

      expect(work1.work_ids).to eq [work2.id, work3.id]
      expect(work1.ordered_work_ids).to eq [work3.id]
    end
  end

  describe "#works" do
    it "returns non-ordered file sets" do
      work1.members << work2
      work1.ordered_members << work3

      expect(work1.works).to eq [work2, work3]
    end
  end

  describe '#ordered_file_set_ids' do
    it 'lists file_set ids' do
      work1.ordered_members = [file_set1, file_set2]
      Deprecation.silence Hydra::Works::WorkBehavior do
        expect(work1.ordered_file_set_ids).to eq [file_set1.id, file_set2.id]
      end
    end
  end

  context 'sub-class' do
    before do
      class TestWork < Hydra::Works::Work
      end
    end

    subject { TestWork.new(ordered_members: [file_set1]) }

    it 'has many file sets' do
      Deprecation.silence Hydra::Works::WorkBehavior do
        expect(subject.ordered_file_sets).to eq [file_set1]
      end
    end
  end

  describe 'Related objects' do
    let(:work1) { described_class.new }
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      work1.related_objects = [object1]
    end

    it 'persists' do
      expect(work1.related_objects).to eq [object1]
    end
  end

  describe '#ordered_works' do
    context 'with acceptable works' do
      context 'with file_sets and works' do
        before do
          subject.ordered_members << file_set1
          subject.ordered_members << file_set2
          subject.ordered_members << work1
          subject.ordered_members << work2
        end

        it 'adds work to work with file_sets and works' do
          subject.ordered_members << work3
          expect(subject.ordered_works).to eq [work1, work2, work3]
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

        it 'accepts implementing work as a child' do
          subject.ordered_members << iwork1
          expect(subject.ordered_works).to eq [iwork1]
        end
      end

      describe 'aggregates works that extend Hydra::Works::Work' do
        before do
          class DummyExtWork < Hydra::Works::Work
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.new }

        it 'accepts extending work as a child' do
          subject.ordered_members << ework1
          expect(subject.ordered_works).to eq [ework1]
        end
      end
    end
  end

  context 'move file set' do
    before do
      subject.ordered_members << file_set1
      subject.ordered_members << file_set2
    end
    it 'moves file from one work to another' do
      Deprecation.silence Hydra::Works::WorkBehavior do
        expect(subject.ordered_file_sets).to eq([file_set1, file_set2])
        expect(work1.ordered_file_sets).to eq([])
        subject.ordered_member_proxies.delete_at(0)
        work1.ordered_members << file_set1
        expect(subject.ordered_file_sets).to eq([file_set2])
        expect(work1.ordered_file_sets).to eq([file_set1])
      end
    end
  end

  describe '#file_sets' do
    it 'returns empty array when only works are aggregated' do
      subject.ordered_members << work1
      subject.ordered_members << work2
      Deprecation.silence Hydra::Works::WorkBehavior do
        expect(subject.ordered_file_sets).to eq []
      end
    end

    context 'with file_sets and works' do
      before do
        subject.ordered_members << file_set1
        subject.ordered_members << file_set2
        subject.ordered_members << work1
        subject.ordered_members << work2
      end

      it 'returns only file_sets' do
        Deprecation.silence Hydra::Works::WorkBehavior do
          expect(subject.ordered_file_sets).to eq [file_set1, file_set2]
        end
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
        subject.ordered_members << work2
        subject.ordered_members << file_set3
        subject.ordered_members << file_set4
        subject.ordered_members << work1
        subject.ordered_members << file_set5
        Deprecation.silence Hydra::Works::WorkBehavior do
          expect(subject.ordered_file_sets).to eq [file_set1, file_set2, file_set3, file_set4, file_set5]
        end
      end

      it 'removes first collection' do
        subject.ordered_member_proxies.delete_at(0)
        Deprecation.silence Hydra::Works::WorkBehavior do
          expect(subject.ordered_file_sets).to eq [file_set2, file_set3, file_set4, file_set5]
        end
        expect(subject.ordered_works).to eq [work2, work1]
      end

      it 'removes last collection' do
        subject.ordered_member_proxies.delete_at(6)
        Deprecation.silence Hydra::Works::WorkBehavior do
          expect(subject.ordered_file_sets).to eq [file_set1, file_set2, file_set3, file_set4]
        end
        expect(subject.ordered_works).to eq [work2, work1]
      end

      it 'removes middle collection' do
        subject.ordered_member_proxies.delete_at(3)
        Deprecation.silence Hydra::Works::WorkBehavior do
          expect(subject.ordered_file_sets).to eq [file_set1, file_set2, file_set4, file_set5]
        end
        expect(subject.ordered_works).to eq [work2, work1]
      end
    end
  end

  describe 'adding collections to works' do
    let(:collection) { Hydra::Works::Collection.new }
    let(:exception) { ActiveFedora::AssociationTypeMismatch }
    let(:error_regex) { /is a Collection and may not be a member of the association/ }
    context 'with ordered members' do
      it 'raises AssociationTypeMismatch with a helpful error message' do
        expect { subject.ordered_members = [collection] }.to raise_error(exception, error_regex)
        expect { subject.ordered_members += [collection] }.to raise_error(exception, error_regex)
        expect { subject.ordered_members << collection }.to raise_error(exception, error_regex)
      end
    end
    context 'with unordered members' do
      it 'raises AssociationTypeMismatch with a helpful error message' do
        expect { subject.members = [collection] }.to raise_error(exception, error_regex)
        expect { subject.members += [collection] }.to raise_error(exception, error_regex)
        expect { subject.members << collection }.to raise_error(exception, error_regex)
      end
    end
  end

  describe 'parent work and collection accessors' do
    let(:collection1) { Hydra::Works::Collection.new }
    before do
      collection1.ordered_members << work2
      work1.ordered_members << work2
      collection1.save
      work1.save
      work2.save
    end

    it 'has parents' do
      expect(work2.member_of).to eq [collection1, work1]
    end
    it 'has a parent collection' do
      expect(work2.in_collections).to eq [collection1]
    end
    it 'has a parent work' do
      expect(work2.in_works).to eq [work1]
    end
  end

  describe 'member_of_collections' do
    let(:collection1) { Hydra::Works::Collection.create }
    before do
      work1.member_of_collections = [collection1]
    end

    it 'is a member of the collection' do
      expect(work1.member_of_collections).to eq [collection1]
      expect(work1.member_of_collection_ids).to eq [collection1.id]
    end
  end
end
