require 'spec_helper'

describe Hydra::Works::GenericFile do

  let(:generic_file1) { Hydra::Works::GenericFile.create }
  let(:generic_file2) { Hydra::Works::GenericFile.create }
  let(:generic_file3) { Hydra::Works::GenericFile.create }
  let(:generic_file4) { Hydra::Works::GenericFile.create }
  let(:generic_file5) { Hydra::Works::GenericFile.create }

  let(:file1) { Hydra::PCDM::GenericFile.create }
  let(:file2) { Hydra::PCDM::GenericFile.create }

  let(:collection1)      { Hydra::Works::Collection.create }
  let(:generic_work1)    { Hydra::Works::GenericWork.create }
  let(:pcdm_collection1) { Hydra::PCDM::Collection.create }
  let(:pcdm_object1)     { Hydra::PCDM::Object.create }
  let(:non_PCDM_object)  { "I'm not a PCDM object" }
  let(:af_base_object)   { ActiveFedora::Base.create }

  # TEST the following behaviors...
  #   1) Hydra::Works::GenericFile can contain (pcdm:hasFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
  #   2) Hydra::Works::GenericFile can contain (pcdm:hasRelatedFile) Hydra::PCDM::File   (inherits from Hydra::PCDM::Object)
  #   3) Hydra::Works::GenericFile can aggregate (pcdm:hasMember) Hydra::Works::GenericFile

  #   4) Hydra::Works::GenericFile can NOT aggregate anything else

  #   5) Hydra::Works::GenericFile can have descriptive metadata
  #   6) Hydra::Works::GenericFile can have access metadata

  describe '#generic_files=' do
    it 'should aggregate generic_files' do
      generic_file1.generic_files = [generic_file2, generic_file3]
      generic_file1.save
      expect(generic_file1.generic_files).to eq [generic_file2, generic_file3]
    end

    xit 'should add a generic_file to the generic_files aggregation' do
      generic_file1.generic_files = [generic_file2,generic_file3]
      generic_file1.save
      generic_file1.generic_files << object4
      expect(generic_file1.generic_files).to eq [generic_file2,generic_file3,generic_file4]
    end

    it 'should aggregate generic_files in a sub-generic_file of a generic_file' do
      generic_file1.generic_files = [generic_file2]
      generic_file1.save
      generic_file2.generic_files = [generic_file3]
      generic_file2.save
      expect(generic_file1.generic_files).to eq [generic_file2]
      expect(generic_file2.generic_files).to eq [generic_file3]
    end

    context 'with unacceptable generic_files' do
      let(:error_message) { "each generic_file must be a hydra works generic file" }

      it 'should NOT aggregate Hydra::Works::Collections in generic_files aggregation' do
        expect{ generic_file1.generic_files = [collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::Works::GenericWorks in generic_files aggregation' do
        expect{ generic_file1.generic_files = [generic_work1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Collection in generic_files aggregation' do
        expect{ generic_file1.generic_files = [pcdm_collection1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate Hydra::PCDM::Objects in generic_files aggregation' do
        expect{ generic_file1.generic_files = [pcdm_object1] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate non-PCDM objects in generic_files aggregation' do
        expect{ generic_file1.generic_files = [non_PCDM_object] }.to raise_error(ArgumentError,error_message)
      end

      it 'should NOT aggregate AF::Base objects in generic_files aggregation' do
        expect{ generic_file1.generic_files = [af_base_object] }.to raise_error(ArgumentError,error_message)
      end
    end

    context 'with acceptable generic_files' do
      describe 'aggregates generic_files that implement Hydra::Works' do
        before do
          class DummyIncFile < ActiveFedora::Base
            include Hydra::Works::GenericFileBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncFile) }
        let(:ifile1) { DummyIncFile.create }
        before do
          generic_file1.generic_files = [ifile1]
          generic_file1.save
        end
        subject { generic_file1.generic_files }
        it { is_expected.to eq [ifile1]}
      end

      describe 'aggregates collections that extend Hydra::Works' do
        before do
          class DummyExtFile < Hydra::Works::GenericFile
          end
        end
        after { Object.send(:remove_const, :DummyExtFile) }
        let(:efile1) { DummyExtFile.create }
        before do
          generic_file1.generic_files = [efile1]
          generic_file1.save
        end
        subject { generic_file1.generic_files }
        it { is_expected.to eq [efile1]}
      end
    end

    describe "adding generic files that are ancestors" do
      let(:error_message) { "a generic file can't be an ancestor of itself" }

      context "when the source generic file is the same" do
        it "raises an error" do
          expect{ generic_file1.generic_files = [generic_file1]}.to raise_error(ArgumentError, error_message)
        end
      end

      before do
        generic_file1.generic_files = [generic_file2]
        generic_file1.save
      end

      it "raises and error" do
        expect{ generic_file2.generic_files = [generic_file1]}.to raise_error(ArgumentError, error_message)
      end

      context "with more ancestors" do
        before do
          generic_file2.generic_files = [generic_file3]
          generic_file2.save
        end

        it "raises an error" do
          expect{ generic_file3.generic_files = [generic_file1]}.to raise_error(ArgumentError, error_message)
        end

        context "with a more complicated example" do
          before do
            generic_file3.generic_files = [generic_file4, generic_file5]
            generic_file3.save
          end

          it "raises errors" do
            expect{ generic_file4.generic_files = [generic_file1]}.to raise_error(ArgumentError, error_message)
            expect{ generic_file4.generic_files = [generic_file2]}.to raise_error(ArgumentError, error_message)
          end
        end
      end
    end
  end

  describe '#generic_files' do
    it 'should return empty array when no members' do
      generic_file1.save
      expect(generic_file1.generic_files).to eq []
    end
  end

  describe 'Related objects' do
    let(:object1) { Hydra::PCDM::Object.create }
    let(:object2) { Hydra::PCDM::Object.create }

    before do
      generic_file1.related_objects = [pcdm_object1]
      generic_file1.save
    end

    it 'persists' do
      expect(generic_file1.reload.related_objects).to eq [pcdm_object1]
    end
  end

  describe '#files' do
    let(:object) { described_class.create }
    let(:file1) { object.files.build }
    let(:file2) { object.files.build }

    before do
      file1.content = "I'm a file"
      file2.content = "I am too"
      object.save!
    end

    subject { described_class.find(object.id).files }

    it { is_expected.to eq [file1, file2] }
  end

  describe 'Related objects' do
    let(:generic_file1) { Hydra::Works::GenericFile.create }
    let(:object1) { Hydra::PCDM::Object.create }

    before do
      generic_file1.related_objects = [object1]
      generic_file1.save
    end

    xit 'persists' do

      expect(generic_file1.reload.related_objects).to eq [object1]
    end
  end

end
