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
      subject.ordered_members << generic_work1
      subject.ordered_members << generic_work2
      expect(subject.collections).to eq []
    end

    context 'with other collections & works' do
      before do
        subject.ordered_members << collection1
        subject.ordered_members << collection2
        subject.ordered_members << generic_work1
        subject.ordered_members << generic_work2
      end

      it 'returns only collections' do
        expect(subject.ordered_collections).to eq [collection1, collection2]
      end
    end
  end

  describe '#works' do
    it 'returns empty array when only collections are aggregated' do
      subject.ordered_members << collection1
      subject.ordered_members << collection2
      expect(subject.ordered_works). to eq []
    end

    context 'with collections and generic works' do
      before do
        subject.ordered_members << collection1
        subject.ordered_members << collection2
        subject.ordered_members << generic_work1
        subject.ordered_members << generic_work2
      end

      it 'returns only generic works' do
        expect(subject.ordered_works). to eq [generic_work1, generic_work2]
      end
    end
  end

  describe "#ordered_work_ids" do
    it "returns IDs of ordered works" do
      subject.ordered_members << generic_work1
      expect(subject.ordered_work_ids).to eq [generic_work1.id]
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

  describe 'have parent collection accessors' do
    before do
      collection1.ordered_members << collection2
      collection1.save
    end

    it 'has parents' do
      expect(collection2.member_of).to eq [collection1]
    end
    it 'has a parent collection' do
      expect(collection2.in_collections).to eq [collection1]
    end
  end
end
