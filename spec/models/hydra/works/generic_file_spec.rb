require 'spec_helper'

describe Hydra::Works::GenericFile do

  describe "#save" do
    it 'is a Hydra::PCDM::Object' do
      generic_file = Hydra::Works::GenericFile.create
      expect(generic_file.save).to be true

      # Waiting for PR with this method be merged into master
      # expect(Hydra::PCDM.object? generic_file).to be true
      expect(generic_file.resource.type.include? RDFVocabularies::PCDMTerms.Object).to be true
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
  
end
