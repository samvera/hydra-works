require 'spec_helper'

describe Hydra::Works do

  let(:works_coll)   { Hydra::Works::Collection.create }
  let(:works_gwork)  { Hydra::Works::GenericWork::Base.create }
  let(:works_gfile)  { Hydra::Works::GenericFile::Base.create }

  let(:pcdm_coll)  { Hydra::PCDM::Collection.create }
  let(:pcdm_obj)   { Hydra::PCDM::Object.create }
  let(:pcdm_file)  { Hydra::PCDM::File.new }

  describe 'Validations' do

    describe "#collection?" do
      it "should return true for a works collection" do
        expect( Hydra::Works.collection? works_coll ).to be true
      end

      it "should return false for a works generic work" do
        expect( Hydra::Works.collection? works_gwork ).to be false
      end

      it "should return false for a works generic file" do
        expect( Hydra::Works.collection? works_gfile ).to be false
      end

      it "should return false for a pcdm collection" do
        expect( Hydra::Works.collection? pcdm_coll ).to be false
      end

      it "should return false for a pcdm object" do
        expect( Hydra::Works.collection? pcdm_obj ).to be false
      end

      it "should return false for a pcdm file" do
        expect( Hydra::Works.collection? pcdm_file ).to be false
      end
    end

    describe "#generic_work?" do
      it "should return false for a works collection" do
        expect( Hydra::Works.generic_work? works_coll ).to be false
      end

      it "should return true for a works generic work" do
        expect( Hydra::Works.generic_work? works_gwork ).to be true
      end

      it "should return false for a works generic file" do
        expect( Hydra::Works.generic_work? works_gfile ).to be false
      end

      it "should return false for a pcdm collection" do
        expect( Hydra::Works.generic_work? pcdm_coll ).to be false
      end

      it "should return false for a pcdm object" do
        expect( Hydra::Works.generic_work? pcdm_obj ).to be false
      end

      it "should return false for a pcdm file" do
        expect( Hydra::Works.generic_work? pcdm_file ).to be false
      end
    end

    describe "#generic_file?" do
      it "should return false for a works collection" do
        expect( Hydra::Works.generic_file? works_coll ).to be false
      end

      it "should return false for a works generic work" do
        expect( Hydra::Works.generic_file? works_gwork ).to be false
      end

      it "should return true for a works generic file" do
        expect( Hydra::Works.generic_file? works_gfile ).to be true
      end

      it "should return false for a pcdm collection" do
        expect( Hydra::Works.generic_file? pcdm_coll ).to be false
      end

      it "should return false for a pcdm object" do
        expect( Hydra::Works.generic_file? pcdm_obj ).to be false
      end

      it "should return false for a pcdm file" do
        expect( Hydra::Works.generic_file? pcdm_file ).to be false
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
