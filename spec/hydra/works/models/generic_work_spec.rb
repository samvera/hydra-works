require 'spec_helper'

describe Hydra::Works::GenericWork do

  let(:generic_work1) { Hydra::Works::GenericWork.create }
  let(:generic_work2) { Hydra::Works::GenericWork.create }
  let(:generic_work3) { Hydra::Works::GenericWork.create }
  let(:generic_work4) { Hydra::Works::GenericWork.create }
  let(:generic_work5) { Hydra::Works::GenericWork.create }

  let(:generic_file1) { Hydra::Works::GenericFile.create }
  let(:generic_file2) { Hydra::Works::GenericFile.create }

  let(:collection1)      { Hydra::Works::Collection.create }
  let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
  let(:pcdm_object1)     { Hydra::PCDM::Object.create }
  let(:pcdm_file1)       { Hydra::PCDM::File.new }
  let(:non_PCDM_object)  { "I'm not a PCDM object" }
  let(:af_base_object)   { ActiveFedora::Base.create }

  # TEST the following behaviors...
  # behavior:
  #   1) Hydra::Works::GenericWork can aggregate Hydra::Works::GenericWork
  #   2) Hydra::Works::GenericWork can aggregate Hydra::Works::GenericFile

  #   3) Hydra::Works::GenericWork can NOT aggregate Hydra::PCDM::Collection
  #   4) Hydra::Works::GenericWork can NOT aggregate Hydra::Works::Collection
  #   5) Hydra::Works::GenericWork can NOT aggregate Works::Object unless it is also a Hydra::Works::GenericFile
  #   6) Hydra::Works::GenericWork can NOT contain PCDM::File
  #   7) Hydra::Works::GenericWork can NOT aggregate non-PCDM object

  #   8) Hydra::Works::GenericWork can NOT contain Hydra::Works::File

  #   9) Hydra::Works::GenericWork can have descriptive metadata
  #   10) Hydra::Works::GenericWork can have access metadata

  describe '#generic_works=' do
    it 'should aggregate generic_works' do
      generic_work1.generic_works = [generic_work2, generic_work3]
      generic_work1.save
      expect(generic_work1.generic_works).to eq [generic_work2, generic_work3]
    end

    xit 'should add a generic_work to the generic_works aggregation' do
      generic_work1.generic_works = [generic_work2,generic_work3]
      generic_work1.save
      generic_work1.generic_works << object4
      expect(generic_work1.generic_works).to eq [generic_work2,generic_work3,generic_work4]
    end

    it 'should aggregate generic_works in a sub-generic_work of a generic_work' do
      generic_work1.generic_works = [generic_work2]
      generic_work1.save
      generic_work2.generic_works = [generic_work3]
      generic_work2.save
      expect(generic_work1.generic_works).to eq [generic_work2]
      expect(generic_work2.generic_works).to eq [generic_work3]
    end

    context 'with unacceptable generic_works' do
      let(:error_message) { "each generic_work must be a hydra works generic work" }

      it 'should NOT aggregate Hydra::Works::Collections in generic_works aggregation' do
        expect{ generic_work1.generic_works = [collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericFiles in generic_works aggregation' do
        expect{ generic_work1.generic_works = [generic_file1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collection in generic_works aggregation' do
        expect{ generic_work1.generic_works = [pcdm_collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic_works aggregation' do
        expect{ generic_work1.generic_works = [pcdm_object1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic_works aggregation' do
        expect{ generic_work1.generic_works = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic_works aggregation' do
        expect{ generic_work1.generic_works = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable generic_works' do
      describe 'aggregates generic_works that implement Hydra::Works' do
        before do
          class DummyIncWork < ActiveFedora::Base
            include Hydra::Works::GenericWorkBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncWork) }
        let(:iwork1) { DummyIncWork.create }
        before do
          generic_work1.generic_works = [iwork1]
          generic_work1.save
        end
        subject { generic_work1.generic_works }
        it { is_expected.to eq [iwork1]}
      end

      describe 'aggregates collections that extend Hydra::Works' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.create }
        before do
          generic_work1.generic_works = [ework1]
          generic_work1.save
        end
        subject { generic_work1.generic_works }
        it { is_expected.to eq [ework1]}
      end
    end

    describe "adding generic works that are ancestors" do
      let(:error_message) { "a generic work can't be an ancestor of itself" }

      context "when the source generic work is the same" do
        it "raises an error" do
          expect{ generic_work1.generic_works = [generic_work1]}.to raise_error(ArgumentError, error_message)
        end
      end

      before do
        generic_work1.generic_works = [generic_work2]
        generic_work1.save
      end

      it "raises and error" do
        expect{ generic_work2.generic_works = [generic_work1]}.to raise_error(ArgumentError, error_message)
      end

      context "with more ancestors" do
        before do
          generic_work2.generic_works = [generic_work3]
          generic_work2.save
        end

        it "raises an error" do
          expect{ generic_work3.generic_works = [generic_work1]}.to raise_error(ArgumentError, error_message)
        end

        context "with a more complicated example" do
          before do
            generic_work3.generic_works = [generic_work4, generic_work5]
            generic_work3.save
          end

          it "raises errors" do
            expect{ generic_work4.generic_works = [generic_work1]}.to raise_error(ArgumentError, error_message)
            expect{ generic_work4.generic_works = [generic_work2]}.to raise_error(ArgumentError, error_message)
          end
        end
      end
    end
  end

  describe '#generic_works' do
    it 'should return empty array when no members' do
      generic_work1.save
      expect(generic_work1.generic_works).to eq []
    end

    it 'should return empty array when only generic_files are aggregated' do
      generic_work1.generic_files = [generic_file1,generic_file2]
      generic_work1.save
      expect(generic_work1.generic_works).to eq []
    end

    it 'should only return generic_works' do
      generic_work1.generic_works = [generic_work2,generic_work3]
      generic_work1.generic_files = [generic_file1,generic_file2]
      generic_work1.save
      expect(generic_work1.generic_works).to eq [generic_work2,generic_work3]
    end
  end

  describe '#generic_files=' do
    it 'should aggregate generic_files' do
      generic_work1.generic_files = [generic_file1, generic_file2]
      generic_work1.save
      expect(generic_work1.generic_files).to eq [generic_file1, generic_file2]
    end

    xit 'should add an generic file to the generic_files aggregation' do
      generic_work1.generic_files = [generic_file1,generic_file2]
      generic_work1.save
      generic_work1.generic_files << object4
      expect(generic_work1.generic_files).to eq [generic_file1,generic_file2,generic_work4]
    end

    context 'with unacceptable generic_files' do
      let(:error_message) { "each generic_file must be a hydra works generic file" }

      it 'should NOT aggregate Hydra::Works::Collections in generic_files aggregation' do
        expect{ generic_work1.generic_files = [collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericWorks in generic_files aggregation' do
        expect{ generic_work1.generic_files = [generic_work2] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collection in generic_files aggregation' do
        expect{ generic_work1.generic_files = [pcdm_collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic_files aggregation' do
        expect{ generic_work1.generic_files = [pcdm_object1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic_files aggregation' do
        expect{ generic_work1.generic_files = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic_files aggregation' do
        expect{ generic_work1.generic_files = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end
  end

  describe '#generic_files' do
    it 'should return empty array when no members' do
      generic_work1.save
      expect(generic_work1.generic_files).to eq []
    end

    it 'should return empty array when only generic_works are aggregated' do
      generic_work1.generic_works = [generic_work2,generic_work3]
      generic_work1.save
      expect(generic_work1.generic_files).to eq []
    end

    it 'should only return generic_files' do
      generic_work1.generic_files = [generic_file1,generic_file2]
      generic_work1.generic_works = [generic_work2,generic_work3]
      generic_work1.save
      expect(generic_work1.generic_files).to eq [generic_file1,generic_file2]
    end
  end

  describe '#contains' do
    it 'should present as a missing method' do
      expect{ generic_work1.contains = [pcdm_file1] }.to raise_error(NoMethodError,"works can not contain files")
    end
  end

  describe 'Related objects' do
    let(:generic_work1) { Hydra::Works::GenericWork.create }
    let(:object1) { Hydra::PCDM::Object.create }

    before do
      generic_work1.related_objects = [object1]
      generic_work1.save
    end

    it 'persists' do
      expect(generic_work1.reload.related_objects).to eq [object1]
    end
  end

end
