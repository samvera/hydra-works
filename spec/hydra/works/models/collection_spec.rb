require 'spec_helper'

describe Hydra::Works::Collection do
  let(:collection) { described_class.new }

  let(:collection1) { described_class.new }
  let(:generic_work1) { Hydra::Works::GenericWork.new }

  describe '#collections' do
    it 'returns empty array when only works are aggregated' do
      collection.ordered_members << generic_work1
      expect(collection.collections).to eq []
    end

    context 'with other collections & works' do
      let(:collection2) { described_class.new }
      before do
        collection.ordered_members << collection1
        collection.ordered_members << collection2
        collection.ordered_members << generic_work1
      end

      it 'returns only collections' do
        expect(collection.ordered_collections).to eq [collection1, collection2]
      end
    end
  end

  describe '#works' do
    subject { collection.works }
    context "when only collections are aggregated" do
      it 'returns empty array when only collections are aggregated' do
        collection.ordered_members << collection1
        expect(subject).to eq []
      end
    end

    context 'with collections and generic works' do
      let(:generic_work2) { Hydra::Works::GenericWork.new }
      before do
        collection.ordered_members << collection1
        collection.ordered_members << generic_work1
        collection.ordered_members << generic_work2
      end

      it 'returns only generic works' do
        expect(subject).to eq [generic_work1, generic_work2]
      end
    end
  end

  describe '#ordered_works' do
    subject { collection.ordered_works }
    context "when only collections are aggregated" do
      it 'returns empty array when only collections are aggregated' do
        collection.ordered_members << collection1
        expect(subject).to eq []
      end
    end

    context 'with collections and generic works' do
      let(:generic_work2) { Hydra::Works::GenericWork.new }
      before do
        collection.ordered_members << collection1
        collection.ordered_members << generic_work1
        collection.ordered_members << generic_work2
      end

      it 'returns only generic works' do
        expect(subject).to eq [generic_work1, generic_work2]
      end
    end
  end

  describe "#ordered_work_ids" do
    subject { collection.ordered_work_ids }
    it "returns IDs of ordered works" do
      collection.ordered_members << generic_work1
      expect(subject).to eq [generic_work1.id]
    end
  end

  describe '#related_objects' do
    subject { collection.related_objects }
    let(:object) { Hydra::PCDM::Object.new }
    let(:collection) { described_class.new }

    before do
      collection.related_objects = [object]
    end

    it { is_expected.to eq [object] }
  end

  describe "#in_collections" do
    before do
      collection1.ordered_members << collection
      collection1.save
    end

    subject { collection.in_collections }
    it { is_expected.to eq [collection1] }
  end
end
