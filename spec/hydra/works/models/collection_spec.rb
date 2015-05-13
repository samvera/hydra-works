require 'spec_helper'

describe Hydra::Works::Collection do

  let(:collection1) { Hydra::Works::Collection.create }
  let(:collection2) { Hydra::Works::Collection.create }
  let(:collection3) { Hydra::Works::Collection.create }
  let(:collection4) { Hydra::Works::Collection.create }
  let(:collection5) { Hydra::Works::Collection.create }

  let(:generic_work1) { Hydra::Works::GenericWork.create }
  let(:generic_work2) { Hydra::Works::GenericWork.create }
  let(:generic_work3) { Hydra::Works::GenericWork.create }

  let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
  let(:pcdm_object1)     { Hydra::PCDM::Object.create }
  let(:non_PCDM_object)  { "I'm not a PCDM object" }
  let(:af_base_object)   { ActiveFedora::Base.create }
  let(:generic_file1)    { Hydra::Works::GenericFile.create }


  # test the following behaviors:
  #   1) Hydra::Works::Collection can aggregate Hydra::Works::Collection
  #   2) Hydra::Works::Collection can aggregate Hydra::Works::GenericWork

  #   3) Hydra::Works::Collection can NOT aggregate Hydra::PCDM::Collection unless it is also a Hydra::Works::Collection
  #   4) Hydra::Works::Collection can NOT aggregate Hydra::Works::GenericFile
  #   5) Hydra::Works::Collection can NOT aggregate non-PCDM object
  #   6) Hydra::Works::Collection can NOT contain Hydra::PCDM::File
  #   7) Hydra::Works::Collection can NOT contain Hydra::Works::File

  #   8) Hydra::Works::Collection can have descriptive metadata
  #   9) Hydra::Works::Collection can have access metadata


  describe '#collections=' do
    it 'should aggregate collections' do
      collection1.collections = [collection2, collection3]
      collection1.save
      expect(collection1.collections).to eq [collection2, collection3]
    end

    xit 'should add a collection to the collections aggregation' do
      collection1.collections = [collection2,collection3]
      collection1.save
      collection1.collections << collection4
      expect(collection1.collections).to eq [collection2, collection3, collection4]
    end

    it 'should aggregate collections in a sub-collection of a collection' do
      collection1.collections = [collection2]
      collection1.save
      collection2.collections = [collection3]
      collection2.save
      expect(collection1.collections).to eq [collection2]
      expect(collection2.collections).to eq [collection3]
    end

    context 'with unacceptable collections' do
      let(:error_message) { "each collection must be a hydra works collection" }

      it 'should NOT aggregate Hydra::Works::GenericWorks in collections aggregation' do
        expect{ collection1.collections = [generic_work1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFiles in collections aggregation' do
        expect{ collection1.collections = [generic_file1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in collections aggregation' do
        expect{ collection1.collections = [pcdm_collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in collections aggregation' do
        expect{ collection1.collections = [pcdm_object1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in collections aggregation' do
        expect{ collection1.collections = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in collections aggregation' do
        expect{ collection1.collections = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable collections' do
      describe 'aggregates collections that implement Hydra::Works' do
        before do
          class Kollection < ActiveFedora::Base
            include Hydra::Works::CollectionBehavior
          end
        end
        after { Object.send(:remove_const, :Kollection) }
        let(:kollection1) { Kollection.create }
        before do
          collection1.collections = [kollection1]
          collection1.save
        end
        subject { collection1.collections }
        it { is_expected.to eq [kollection1]}
      end

      describe 'aggregates collections that extend Hydra::Works' do
        before do
          class Cullection < Hydra::Works::Collection
          end
        end
        after { Object.send(:remove_const, :Cullection) }
        let(:cullection1) { Cullection.create }
        before do
          collection1.collections = [cullection1]
          collection1.save
        end
        subject { collection1.collections }
        it { is_expected.to eq [cullection1]}
      end
    end

    describe "adding collections that are ancestors" do
      let(:error_message) { "a collection can't be an ancestor of itself" }

      context "when the source collection is the same" do
        it "raises an error" do
          expect{ collection1.collections = [collection1]}.to raise_error(ArgumentError, error_message)
        end
      end

      before do
        collection1.collections = [collection2]
        collection1.save
      end

      it "raises and error" do
        expect{ collection2.collections = [collection1]}.to raise_error(ArgumentError, error_message)
      end

      context "with more ancestors" do
        before do
          collection2.collections = [collection3]
          collection2.save
        end

        it "raises an error" do
          expect{ collection3.collections = [collection1]}.to raise_error(ArgumentError, error_message)
        end

        context "with a more complicated example" do
          before do
            collection3.collections = [collection4, collection5]
            collection3.save
          end

          it "raises errors" do
            expect{ collection4.collections = [collection1]}.to raise_error(ArgumentError, error_message)
            expect{ collection4.collections = [collection2]}.to raise_error(ArgumentError, error_message)
          end
        end
      end
    end
  end

  describe '#collections' do
    it 'should return empty array when no members' do
      collection1.save
      expect(collection1.collections).to eq []
    end

    it 'should return empty array when only generic_works are aggregated' do
      collection1.generic_works = [generic_work1,generic_work2]
      collection1.save
      expect(collection1.collections).to eq []
    end

    it 'should only return collections' do
      collection1.collections = [collection2,collection3]
      collection1.generic_works = [generic_work1,generic_work2]
      collection1.save
      expect(collection1.collections).to eq [collection2,collection3]
    end
  end


  describe '#generic_works=' do
    it 'should aggregate generic_works' do
      collection1.generic_works = [generic_work1,generic_work2]
      collection1.save
      expect(collection1.generic_works).to eq [generic_work1,generic_work2]
    end

    xit 'should add an generic_work to the generic_works aggregation' do
      collection1.generic_works = [generic_work1,generic_work2]
      collection1.save
      collection1.generic_works << generic_work3
      expect(collection1.generic_works).to eq [generic_work1,generic_work2,generic_work3]
    end

    context "with unacceptable objects" do
      let(:error_message) { "each generic_work must be a hydra works generic work" }

      it 'should NOT aggregate Hydra::Works::Collection in generic_works aggregation' do
        expect{ collection1.generic_works = [collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFiles in collections aggregation' do
        expect{ collection1.generic_works = [generic_file1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collection in generic_works aggregation' do
        expect{ collection1.generic_works = [pcdm_collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic_works aggregation' do
        expect{ collection1.generic_works = [pcdm_object1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic_works aggregation' do
        expect{ collection1.generic_works = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic_works aggregation' do
        expect{ collection1.generic_works = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable generic_works' do
      describe 'aggregates generic_works that implement Hydra::PCDM' do
        before do
          class Ahbject < ActiveFedora::Base
            include Hydra::PCDM::ObjectBehavior
            include Hydra::Works::GenericWorkBehavior
          end
        end
        after { Object.send(:remove_const, :Ahbject) }
        let(:ahbject1) { Ahbject.create }
        before do
          collection1.generic_works = [ahbject1]
          collection1.save
        end
        subject { collection1.generic_works }
        it { is_expected.to eq [ahbject1]}
      end

      describe 'aggregates generic_works that extend Hydra::PCDM' do
        before do
          class Awbject < Hydra::Works::GenericWork
          end
        end
        after { Object.send(:remove_const, :Awbject) }
        let(:awbject1) { Awbject.create }
        before do
          collection1.generic_works = [awbject1]
          collection1.save
        end
        subject { collection1.generic_works }
        it { is_expected.to eq [awbject1]}
      end
    end
  end

  describe '#generic_works' do
    it 'should return empty array when no members' do
      collection1.save
      expect(collection1.generic_works).to eq []
    end

    it 'should return empty array when only collections are aggregated' do
      collection1.collections = [collection2,collection3]
      collection1.save
      expect(collection1.generic_works).to eq []
    end

    it 'should only return generic_works' do
      collection1.collections = [collection2,collection3]
      collection1.generic_works = [generic_work1,generic_work2]
      collection1.save
      expect(collection1.generic_works).to eq [generic_work1,generic_work2]
    end
  end

  describe 'Related objects' do
    let(:object) { Hydra::PCDM::Object.create }
    let(:collection) { Hydra::Works::Collection.create }

    before do
      collection.related_objects = [object]
      collection.save
    end

    it 'persists' do
      expect(collection.reload.related_objects).to eq [object]
    end
  end
end
