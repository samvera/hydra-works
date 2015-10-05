require 'spec_helper'

describe Hydra::Works do
  let(:works_coll)   { Hydra::Works::Collection.new }
  let(:works_gwork)  { Hydra::Works::GenericWork.new }
  let(:works_gfile)  { Hydra::Works::GenericFile::Base.new }

  let(:pcdm_coll)  { Hydra::PCDM::Collection.new }
  let(:pcdm_obj)   { Hydra::PCDM::Object.new }
  let(:pcdm_file)  { Hydra::PCDM::File.new }

  describe 'Validations' do
    describe '#collection?' do
      it 'returns true for a works collection' do
        expect(works_coll.collection?).to be true
      end

      it 'returns false for a works generic work' do
        expect(works_gwork.collection?).to be false
      end

      it 'returns false for a works generic file' do
        expect(works_gfile.collection?).to be false
      end
    end

    describe '#work?' do
      it 'returns false for a collection' do
        expect(works_coll.work?).to be false
      end

      it 'returns true for a generic work' do
        expect(works_gwork.work?).to be true
      end

      it 'returns false for a generic file' do
        expect(works_gfile.work?).to be false
      end
    end

    describe '#generic_file?' do
      it 'returns false for a works collection' do
        expect(works_coll.generic_file?).to be false
      end

      it 'returns false for a works generic work' do
        expect(works_gwork.generic_file?).to be false
      end

      it 'returns true for a works generic file' do
        expect(works_gfile.generic_file?).to be true
      end
    end
  end

  describe 'Hydra::PCDM' do
    describe '#collection?' do
      it 'returns true for a works collection' do
        expect(Hydra::PCDM.collection? works_coll).to be true
      end

      it 'returns false for a works generic work' do
        expect(Hydra::PCDM.collection? works_gwork).to be false
      end

      it 'returns false for a works generic file' do
        expect(Hydra::PCDM.collection? works_gfile).to be false
      end

      it 'returns true for a pcdm collection' do
        expect(Hydra::PCDM.collection? pcdm_coll).to be true
      end

      it 'returns false for a pcdm object' do
        expect(Hydra::PCDM.collection? pcdm_obj).to be false
      end

      it 'returns false for a pcdm file' do
        expect(Hydra::PCDM.collection? pcdm_file).to be false
      end
    end

    describe '#object?' do
      it 'returns false for a works collection' do
        expect(Hydra::PCDM.object? works_coll).to be false
      end

      it 'returns true for a works generic work' do
        expect(Hydra::PCDM.object? works_gwork).to be true
      end

      it 'returns true for a works generic file' do
        expect(Hydra::PCDM.object? works_gfile).to be true
      end

      it 'returns false for a pcdm collection' do
        expect(Hydra::PCDM.object? pcdm_coll).to be false
      end

      it 'returns true for a pcdm object' do
        expect(Hydra::PCDM.object? pcdm_obj).to be true
      end

      it 'returns false for a pcdm file' do
        expect(Hydra::PCDM.object? pcdm_file).to be false
      end
    end
  end
end
