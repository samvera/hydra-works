require 'spec_helper'

describe Hydra::Works::GenericWork do

  subject { Hydra::Works::GenericWork::Base.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work4) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work5) { Hydra::Works::GenericWork::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }

  let(:object1) { Hydra::PCDM::Object.new }
  let(:object2) { Hydra::PCDM::Object.new }

  let(:pcdm_file1)       { Hydra::PCDM::File.new }

  describe '#child_generic_works=' do
    it 'should aggregate generic_works' do
      generic_work1.child_generic_works = [generic_work2, generic_work3]
      expect(generic_work1.child_generic_works).to eq [generic_work2, generic_work3]
    end
  end

  describe '#generic_files=' do
    it 'should aggregate generic_files' do
      generic_work1.generic_files = [generic_file1, generic_file2]
      expect(generic_work1.generic_files).to eq [generic_file1, generic_file2]
    end
  end

  describe '#generic_file_ids' do
    it 'should list child generic_file ids' do
      generic_work1.generic_files = [generic_file1, generic_file2]
      expect(generic_work1.generic_file_ids).to eq [generic_file1.id, generic_file2.id]
    end
  end

  context "sub-class" do
    before do
      class TestWork < Hydra::Works::GenericWork::Base
      end
    end

    subject { TestWork.new(generic_files: [generic_file1]) }

    it "should have many generic files" do
      expect(subject.generic_files).to eq [generic_file1]
    end
  end

  describe '#contains' do
    it 'should present as a missing method' do
      expect{ generic_work1.contains = [pcdm_file1] }.to raise_error(NoMethodError,"works can not directly contain files.  You must add a GenericFile to the work's members and add files to that GenericFile.")
    end
  end

  describe 'Related objects' do
    let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      generic_work1.related_objects = [object1]
    end

    it 'persists' do
      expect(generic_work1.related_objects).to eq [object1]
    end
  end

  describe '#child_generic_works' do
    context 'with acceptable generic_works' do

      context 'with generic_files and generic_works' do
        before do
          subject.generic_files << generic_file1
          subject.generic_files << generic_file2
          subject.child_generic_works << generic_work1
          subject.child_generic_works << generic_work2
        end

        it 'should add generic_work to generic_work with generic_files and generic_works' do
          subject.child_generic_works << generic_work3
          expect(subject.child_generic_works).to eq [generic_work1,generic_work2,generic_work3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr['generic_works_ssim']).to include(generic_work1.id,generic_work2.id,generic_work3.id)
          expect(subject.to_solr['generic_works_ssim']).not_to include(generic_file1.id,generic_file2.id)
          expect(subject.to_solr['generic_files_ssim']).to include(generic_file1.id,generic_file2.id)
          expect(subject.to_solr['generic_files_ssim']).not_to include(generic_work1.id,generic_work2.id,generic_work3.id)
        end
        end
      end

      describe 'aggregates generic_works that implement Hydra::Works::GenericWorkBehavior' do
        before do
          class DummyIncWork < ActiveFedora::Base
            include Hydra::Works::GenericWorkBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncWork) }
        let(:iwork1) { DummyIncWork.new }

        it 'should accept implementing generic_work as a child' do
          subject.child_generic_works << iwork1
          expect(subject.child_generic_works).to eq [iwork1]
        end
      end

      describe 'aggregates generic_works that extend Hydra::Works::GenericWork::Base' do
        before do
          class DummyExtWork < Hydra::Works::GenericWork::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtWork) }
        let(:ework1) { DummyExtWork.new }

        it 'should accept extending generic_work as a child' do
          subject.child_generic_works << ework1
          expect(subject.child_generic_works).to eq [ework1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @generic_work102      = Hydra::Works::GenericWork::Base.new

        @works_collection101  = Hydra::Works::Collection.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_PCDM_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic works' do

        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(GenericFile::Base|Collection) with ID:  was expected to works_generic_work\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `works_generic_work\?' for .*/ }

        it 'should NOT aggregate Hydra::Works::Collection in generic works aggregation' do
          expect{ subject.child_generic_works << @works_collection101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericFile in generic works aggregation' do
          expect{ subject.child_generic_works << @generic_file101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in generic works aggregation' do
          expect{ subject.child_generic_works << @pcdm_collection101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in generic works aggregation' do
          expect{ subject.child_generic_works << @pcdm_object101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in generic works aggregation' do
          expect{ subject.child_generic_works << @pcdm_file101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in generic works aggregation' do
          expect{ subject.child_generic_works << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in generic works aggregation' do
          expect{ subject.child_generic_works << @af_base_object }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end

  describe '#generic_files <<' do
    it 'should return empty array when only generic_files are aggregated' do
      subject.generic_files << generic_file1
      subject.generic_files << generic_file2
      expect(subject.child_generic_works).to eq []
    end

    context 'with generic_files and generic_works' do
      before do
        subject.generic_files << generic_file1
        subject.generic_files << generic_file2
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work2
      end

      it 'should only return generic_works' do
        expect(subject.child_generic_works).to eq [generic_work1,generic_work2]
      end
   end
  end

  describe '#child_generic_works.delete' do
    context 'when multiple collections' do
      before do
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work2
        subject.generic_files << generic_file2
        subject.child_generic_works << generic_work3
        subject.child_generic_works << generic_work4
        subject.generic_files << generic_file1
        subject.child_generic_works << generic_work5
        expect(subject.child_generic_works).to eq [generic_work1,generic_work2,generic_work3,generic_work4,generic_work5]
      end

      it 'should remove first collection' do
        expect(subject.child_generic_works.delete generic_work1).to eq [generic_work1]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work3,generic_work4,generic_work5]
        expect(subject.generic_files).to eq [generic_file2,generic_file1]
      end

      it 'should remove last collection' do
        expect(subject.child_generic_works.delete generic_work5).to eq [generic_work5]
        expect(subject.child_generic_works).to eq [generic_work1,generic_work2,generic_work3,generic_work4]
        expect(subject.generic_files).to eq [generic_file2,generic_file1]
      end

      it 'should remove middle collection' do
        expect(subject.child_generic_works.delete generic_work3).to eq [generic_work3]
        expect(subject.child_generic_works).to eq [generic_work1,generic_work2,generic_work4,generic_work5]
        expect(subject.generic_files).to eq [generic_file2,generic_file1]
      end
    end
  end

  describe '#child_generic_works <<' do
    context 'with acceptable generic_works' do
      context 'with generic_files and generic_works' do
        let(:generic_file3) { Hydra::Works::GenericFile::Base.new }
        before do
          subject.generic_files << generic_file1
          subject.generic_files << generic_file2
          subject.child_generic_works << generic_work1
          subject.child_generic_works << generic_work2
        end

        it 'should add generic_file to generic_work with generic_files and generic_works' do
          subject.generic_files << generic_file3
          expect(subject.generic_files).to eq [generic_file1,generic_file2,generic_file3]
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(generic_file1.id,generic_file2.id,generic_file3.id)
          expect(subject.to_solr["generic_files_ssim"]).to include(generic_file1.id,generic_file2.id,generic_file3.id)
          expect(subject.to_solr["generic_files_ssim"]).not_to include(generic_work1.id,generic_work2.id)
        end
        end
      end

      describe 'aggregates generic_files that implement Hydra::Works::GenericFileBehavior' do
        before do
          class DummyIncFile < ActiveFedora::Base
            include Hydra::Works::GenericFileBehavior
          end
        end
        after { Object.send(:remove_const, :DummyIncFile) }
        let(:ifile1) { DummyIncFile.new }

        it 'should accept implementing generic_file as a child' do
          subject.generic_files << ifile1
          expect(subject.generic_files).to eq [ifile1]
        end

      end

      describe 'aggregates generic_files that extend Hydra::Works::GenericFile::Base' do
        before do
          class DummyExtFile < Hydra::Works::GenericFile::Base
          end
        end
        after { Object.send(:remove_const, :DummyExtFile) }
        let(:efile1) { DummyExtFile.new }

        it 'should accept extending generic_file as a child' do
          subject.generic_files << efile1
          expect(subject.generic_files).to eq [efile1]
        end
      end
    end

    context 'with unacceptable inputs' do
      before(:all) do
        @generic_work102      = Hydra::Works::GenericWork::Base.new

        @works_collection101  = Hydra::Works::Collection.new
        @generic_work101      = Hydra::Works::GenericWork::Base.new
        @generic_file101      = Hydra::Works::GenericFile::Base.new
        @pcdm_collection101   = Hydra::PCDM::Collection.new
        @pcdm_object101       = Hydra::PCDM::Object.new
        @pcdm_file101         = Hydra::PCDM::File.new
        @non_PCDM_object      = "I'm not a PCDM object"
        @af_base_object       = ActiveFedora::Base.new
      end

      context 'that are unacceptable child generic files' do

        let(:error_type1)    { ArgumentError }
        let(:error_message1) { /Hydra::Works::(GenericWork::Base|Collection) with ID:  was expected to works_generic_file\?, but it was false/ }
        let(:error_type2)    { NoMethodError }
        let(:error_message2) { /undefined method `works_generic_file\?' for .*/ }

        it 'should NOT aggregate Hydra::Works::Collection in generic files aggregation' do
          expect{ subject.generic_files << @works_collection101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::Works::GenericWork in generic files aggregation' do
          expect{ subject.generic_files << @generic_work101 }.to raise_error(error_type1,error_message1)
        end

        it 'should NOT aggregate Hydra::PCDM::Collections in generic files aggregation' do
          expect{ subject.generic_files << @pcdm_collection101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Objects in generic files aggregation' do
          expect{ subject.generic_files << @pcdm_object101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate Hydra::PCDM::Files in generic files aggregation' do
          expect{ subject.generic_files << @pcdm_file101 }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate non-PCDM objects in generic files aggregation' do
          expect{ subject.generic_files << @non_PCDM_object }.to raise_error(error_type2,error_message2)
        end

        it 'should NOT aggregate AF::Base objects in generic files aggregation' do
          expect{ subject.generic_files << @af_base_object }.to raise_error(error_type2,error_message2)
        end
      end
    end
  end

  context "move generic file" do 
    before do 
      subject.generic_files << generic_file1
      subject.generic_files << generic_file2
    end
    it "moves file from one work to another" do
      expect(subject.generic_files).to eq([generic_file1, generic_file2])
      expect(generic_work1.generic_files).to eq([])
      generic_work1.generic_files << subject.generic_files.delete(generic_file1)
      expect(subject.generic_files).to eq([generic_file2])
      expect(generic_work1.generic_files).to eq([generic_file1])
    end
  end

  describe '#generic_files' do
    it 'should return empty array when only generic_works are aggregated' do
      subject.child_generic_works << generic_work1
      subject.child_generic_works << generic_work2
      expect(subject.generic_files).to eq []
    end

    context 'with generic_files and generic_works' do
      before do
        subject.generic_files << generic_file1
        subject.generic_files << generic_file2
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work2
      end

      it 'should only return generic_files' do
        expect(subject.generic_files).to eq [generic_file1,generic_file2]
      end
   end
  end

  describe '#generic_files.delete' do
    context 'when multiple collections' do
      let(:generic_file3) { Hydra::Works::GenericFile::Base.new }
      let(:generic_file4) { Hydra::Works::GenericFile::Base.new }
      let(:generic_file5) { Hydra::Works::GenericFile::Base.new }
      before do
        subject.generic_files << generic_file1
        subject.generic_files << generic_file2
        subject.child_generic_works << generic_work2
        subject.generic_files << generic_file3
        subject.generic_files << generic_file4
        subject.child_generic_works << generic_work1
        subject.generic_files << generic_file5
        expect(subject.generic_files).to eq [generic_file1,generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove first collection' do
        expect(subject.generic_files.delete generic_file1).to eq [generic_file1]
        expect(subject.generic_files).to eq [generic_file2,generic_file3,generic_file4,generic_file5]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work1]
      end

      it 'should remove last collection' do
        expect(subject.generic_files.delete generic_file5).to eq [generic_file5]
        expect(subject.generic_files).to eq [generic_file1,generic_file2,generic_file3,generic_file4]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work1]
      end

      it 'should remove middle collection' do
        expect(subject.generic_files.delete generic_file3).to eq [generic_file3]
        expect(subject.generic_files).to eq [generic_file1,generic_file2,generic_file4,generic_file5]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work1]
      end
    end
  end

  describe '#related_objects' do

    context 'with acceptable related objects' do

      it 'should add various types of related objects to generic_work' do
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

      context 'with generic_works and generic_files' do
        before do
          subject.generic_files << generic_file1
          subject.generic_files << generic_file2
          subject.child_generic_works << generic_work1
          subject.child_generic_works << generic_work2
          subject.related_objects << object1
        end

        it 'should add a related object to generic_work with generic_works and generic_files' do
          subject.related_objects << object2
          subject.save
          subject.reload
          expect(subject.related_objects.include? object1).to be true
          expect(subject.related_objects.include? object2).to be true
          expect(subject.related_objects.size).to eq 2
        end

        it 'should solrize member ids' do
          skip 'skipping this test because issue #109 needs to be addressed' do
          expect(subject.to_solr["generic_works_ssim"]).to include(generic_work1.id,generic_work2.id)
          expect(subject.to_solr["generic_works_ssim"]).not_to include(generic_file2.id,generic_file1.id,object1.id,object2.id)
          expect(subject.to_solr["generic_files_ssim"]).to include(generic_file2.id,generic_file1.id)
          expect(subject.to_solr["generic_files_ssim"]).not_to include(object1.id,object2.id,generic_work1.id,generic_work2.id)
          expect(subject.to_solr["related_objects_ssim"]).to include(object1.id,object2.id)
          expect(subject.to_solr["related_objects_ssim"]).not_to include(generic_file2.id,generic_file1.id,generic_work1.id,generic_work2.id)
        end
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

      it 'should NOT aggregate Hydra::Works::Collection in related objects aggregation' do
        expect{ subject.related_objects << collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::Works::Collection:.*> is not a PCDM object./)
      end

      it 'should NOT aggregate Hydra::PCDM::Collections in related objects aggregation' do
        expect{ subject.related_objects << pcdm_collection1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /Hydra::PCDM::Collection:.*> is not a PCDM object./)
      end

      it 'should NOT aggregate Hydra::PCDM::Files in related objects aggregation' do
        expect{ subject.related_objects << pcdm_file1 }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got Hydra::PCDM::File.*/)
      end

      it 'should NOT aggregate non-PCDM objects in related objects aggregation' do
        expect{ subject.related_objects << non_PCDM_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* expected, got String.*/)
      end

      it 'should NOT aggregate AF::Base objects in related objects aggregation' do
        expect{ subject.related_objects << af_base_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base:.*> is not a PCDM object./)
      end
    end

    context 'with invalid bahaviors' do
      it 'should NOT allow related objects to repeat' do
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
    context 'with generic files and works' do
      before do
        subject.child_generic_works << generic_work1
        subject.child_generic_works << generic_work1
        subject.generic_files << generic_file1
      end

      it 'should return empty array when only generic files and generic works are aggregated' do
        expect(subject.related_objects).to eq []
      end

      it 'should only return related objects' do
        subject.related_objects << object2
        expect(subject.related_objects).to eq [object2]
      end

      it 'should return related objects of various types' do
        subject.related_objects << generic_work2
        subject.related_objects << generic_file1
        subject.related_objects << object1
        expect(subject.related_objects).to eq [generic_work2,generic_file1,object1]
        expect(subject.related_objects.size).to eq 3
      end
   end
  end

  describe '#related_objects.delete' do
    context 'when multiple related objects' do
      let(:related_object1) { Hydra::PCDM::Object.new }
      let(:related_work2) { Hydra::Works::GenericWork::Base.new }
      let(:related_file3) { Hydra::Works::GenericFile::Base.new }
      let(:related_object4) { Hydra::PCDM::Object.new }
      let(:related_work5) { Hydra::Works::GenericWork::Base.new }
      before do
        subject.related_objects << related_object1
        subject.related_objects << related_work2
        subject.child_generic_works << generic_work2
        subject.generic_files << generic_file1
        subject.related_objects << related_file3
        subject.related_objects << related_object4
        subject.child_generic_works << generic_work1
        subject.related_objects << related_work5
        expect(subject.related_objects).to eq [related_object1,related_work2,related_file3,related_object4,related_work5]
      end

      it 'should remove first related object' do
        expect(subject.related_objects.delete related_object1).to eq [related_object1]
        expect(subject.related_objects).to eq [related_work2,related_file3,related_object4,related_work5]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work1]
        expect(subject.generic_files).to eq [generic_file1]
      end

      it 'should remove last related object' do
        expect(subject.related_objects.delete related_work5).to eq [related_work5]
        expect(subject.related_objects).to eq [related_object1,related_work2,related_file3,related_object4]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work1]
        expect(subject.generic_files).to eq [generic_file1]
      end

      it 'should remove middle related object' do
        expect(subject.related_objects.delete related_file3).to eq [related_file3]
        expect(subject.related_objects).to eq [related_object1,related_work2,related_object4,related_work5]
        expect(subject.child_generic_works).to eq [generic_work2,generic_work1]
        expect(subject.generic_files).to eq [generic_file1]
      end
    end
  end
end
