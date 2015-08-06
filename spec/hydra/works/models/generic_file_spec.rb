require 'spec_helper'

describe Hydra::Works::GenericFile::Base do

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }

  describe 'Related objects' do
    let(:object1) { Hydra::PCDM::Object.new }

    before do
      generic_file1.related_objects = [object1]
    end

    it 'persists' do
      expect(generic_file1.related_objects).to eq [object1]
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

  describe 'add related object' do

    let(:subject) { Hydra::Works::GenericFile::Base.new }

    describe 'begin test' do

      context 'with acceptable related objects' do
        let(:object1) { Hydra::PCDM::Object.create }
        let(:object2) { Hydra::PCDM::Object.new }
        let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
        let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
        let(:generic_file1) { Hydra::Works::GenericFile::Base.create }

        it 'should add various types of related objects to generic_file' do
          subject.related_objects << generic_work1
          subject.related_objects << generic_file1
          subject.related_objects << object1
          subject.save
          subject.reload
          related_objects = subject.related_objects
          expect( related_objects.include? generic_work1 ).to be true
          expect( related_objects.include? generic_file1 ).to be true
          expect( related_objects.include? object1 ).to be true
          expect( related_objects.size ).to eq 3
        end

        context 'with files and generic_files' do
          let(:file1) { subject.files.build }
          let(:file2) { subject.files.build }
          
          before do
            subject.save
            file1.content = "I'm a file"
            file2.content = "I am too"
            subject.related_objects << object1
          end

          it 'should add a related object to a generic_file with files and generic_files' do
            subject.related_objects << object2 
            subject.save
            subject.reload
            related_objects = subject.related_objects
            expect( related_objects.include? object1 ).to be true
            expect( related_objects.include? object2 ).to be true
            expect( related_objects.size ).to eq 2
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
          expect{ subject.related_objects << af_base_object }.to raise_error(ActiveFedora::AssociationTypeMismatch, /ActiveFedora::Base.* is not a PCDM object./)
          
        end
      end
      
      context 'with invalid behaviors' do
        let(:object1) { Hydra::PCDM::Object.new }
        let(:object2) { Hydra::PCDM::Object.new }

        it 'should NOT allow related objects to repeat' do
          skip 'skipping this test because issue pcdm#92 needs to be addressed' do
            subject.related_objects << object1   
            subject.related_objects << object2
            subject.related_objects << object1
            subject.save
            subject.reload
            related_objects = subject.related_objects
            expect( related_objects.include? object1 ).to be true
            expect( related_objects.include? object2 ).to be true
            expect( related_objects.size ).to eq 2
          end
        end
      end
    end
  end
 
  describe 'get related objects from generic file' do

    subject { Hydra::Works::GenericFile::Base.new }

    let(:object1) { Hydra::PCDM::Object.new }
    let(:object2) { Hydra::PCDM::Object.new }

    let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
    let(:generic_file1) { Hydra::Works::GenericFile::Base.new }

    context 'with generic files' do
      it 'should return empty array when only generic files are aggregated' do
        expect( related_objects = subject.related_objects ).to eq []
      end

      it 'should return related objects' do
        subject.related_objects << object2 
        expect( related_objects = subject.related_objects ).to eq [object2]
      end

      it 'should return related objects of various types' do
        subject.related_objects << generic_work1 
        subject.related_objects << generic_file1 
        subject.related_objects << object1
        subject.save
        subject.reload
        related_objects = subject.related_objects
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? generic_work1 ).to be true
        expect( related_objects.include? generic_file1 ).to be true
        expect( related_objects.size ).to eq 3
      end
    end
  end

  describe 'remove related object from related object' do

    subject { Hydra::Works::GenericFile::Base.new }

    let(:related_object1) { Hydra::PCDM::Object.new }
    let(:related_work2)   { Hydra::Works::GenericWork::Base.new }
    let(:related_file3)   { Hydra::Works::GenericFile::Base.new }
    let(:related_object4) { Hydra::PCDM::Object.new }
    let(:related_work5)   { Hydra::Works::GenericWork::Base.new }

    let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
    let(:generic_file2) { Hydra::Works::GenericFile::Base.new }

    context 'when multiple related objects' do
      before do
        subject.related_objects << related_object1 
        subject.related_objects << related_work2
        subject.related_objects << related_file3
        subject.related_objects << related_object4 
        subject.related_objects << related_work5 
        expect( related_ojects = subject.related_objects ).to eq [related_object1,related_work2,related_file3,related_object4,related_work5]

      end

      it 'should remove first related object' do
        expect( subject.related_objects.delete related_object1 ).to eq [related_object1]
        expect( related_objects = subject.related_objects).to eq [related_work2,related_file3,related_object4,related_work5]
      end

      it 'should remove last related object' do
        expect( subject.related_objects.delete related_work5 ).to eq [related_work5]
        expect( related_objects = subject.related_objects ).to eq [related_object1,related_work2,related_file3,related_object4]
      end

      it 'should remove middle related object' do
        expect( subject.related_objects.delete related_file3  ).to eq [related_file3]
        expect( related_objects = subject.related_objects ).to eq [related_object1,related_work2,related_object4,related_work5]
      end
    end

    #Assuming this context not needed because unacceptable related objects 
    #can't be added.
    #context 'with unacceptable related object' do

  end

  describe "should have parent work accessors" do
    let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
    before do
      generic_work1.generic_files << generic_file1
    end

    it 'should have parents' do
      expect(generic_file1.parents).to eq [generic_work1]
    end
    it 'should have a parent work' do
      expect(generic_file1.generic_works).to eq [generic_work1]
    end
  end


end
