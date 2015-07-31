require 'spec_helper'

describe Hydra::Works do

  let(:works_coll)   { Hydra::Works::Collection.new }
  let(:works_gwork)  { Hydra::Works::GenericWork::Base.new }
  let(:works_gfile)  { Hydra::Works::GenericFile::Base.new }

  let(:pcdm_coll)  { Hydra::PCDM::Collection.new }
  let(:pcdm_obj)   { Hydra::PCDM::Object.new }
  let(:pcdm_file)  { Hydra::PCDM::File.new }

  describe 'Validations' do

    describe "#works_collection?" do
      it "should return true for a works collection" do
        expect( works_coll.works_collection? ).to be true
      end

      it "should return false for a works generic work" do
        expect( works_gwork.works_collection? ).to be false
      end

      it "should return false for a works generic file" do
        expect( works_gfile.works_collection? ).to be false
      end

      it "should return that method is not available for pcdm a collection" do
        expect(pcdm_coll).not_to respond_to(:works_collection?)
      end

      it "should return that method is not available for a pcdm object" do
        expect(pcdm_obj).not_to respond_to(:works_collection?)
      end

      it "should return that method is not available for a pcdm file" do
        expect(pcdm_file).not_to respond_to(:works_collection?)
      end
    end

    describe "#works_generic_work?" do
      it "should return false for a works collection" do
        expect( works_coll.works_generic_work? ).to be false
      end

      it "should return true for a works generic work" do
        expect( works_gwork.works_generic_work? ).to be true
      end

      it "should return false for a works generic file" do
        expect( works_gfile.works_generic_work? ).to be false
      end

      it "should return that method is not available for a pcdm collection" do
        expect(pcdm_coll).not_to respond_to(:works_generic_work?)
      end

      it "should return that method is not available for a pcdm object" do
        expect(pcdm_obj).not_to respond_to(:works_generic_work?)
      end

      it "should return that method is not available for a pcdm file" do
        expect(pcdm_file).not_to respond_to(:works_generic_work?)
      end
    end

    describe "#works_generic_file?" do
      it "should return false for a works collection" do
        expect( works_coll.works_generic_file? ).to be false
      end

      it "should return false for a works generic work" do
        expect( works_gwork.works_generic_file? ).to be false
      end

      it "should return true for a works generic file" do
        expect( works_gfile.works_generic_file? ).to be true
      end

      it "should return that method is not available for a pcdm collection" do
        expect(pcdm_coll).not_to respond_to(:works_generic_file?)
      end

      it "should return that method is not available for a pcdm object" do
        expect(pcdm_obj).not_to respond_to(:works_generic_file?)
      end

      it "should return that method is not available for a pcdm file" do
        expect(pcdm_file).not_to respond_to(:works_generic_file?)
      end
    end
  end

  describe "Hydra::PCDM" do
    describe "#collection?" do
      it "should return true for a works collection" do
        expect( Hydra::PCDM.collection? works_coll ).to be true
      end

      it "should return false for a works generic work" do
        expect( Hydra::PCDM.collection? works_gwork ).to be false
      end

      it "should return false for a works generic file" do
        expect( Hydra::PCDM.collection? works_gfile ).to be false
      end

      it "should return true for a pcdm collection" do
        expect( Hydra::PCDM.collection? pcdm_coll ).to be true
      end

      it "should return false for a pcdm object" do
        expect( Hydra::PCDM.collection? pcdm_obj ).to be false
      end

      it "should return false for a pcdm file" do
        expect( Hydra::PCDM.collection? pcdm_file ).to be false
      end
    end

    describe "#object?" do
      it "should return false for a works collection" do
        expect( Hydra::PCDM.object? works_coll ).to be false
      end

      it "should return true for a works generic work" do
        expect( Hydra::PCDM.object? works_gwork ).to be true
      end

      it "should return true for a works generic file" do
        expect( Hydra::PCDM.object? works_gfile ).to be true
      end

      it "should return false for a pcdm collection" do
        expect( Hydra::PCDM.object? pcdm_coll ).to be false
      end

      it "should return true for a pcdm object" do
        expect( Hydra::PCDM.object? pcdm_obj ).to be true
      end

      it "should return false for a pcdm file" do
        expect( Hydra::PCDM.object? pcdm_file ).to be false
      end
    end

  end

end
