require 'spec_helper'

describe Hydra::Works::ContainedFiles do

  let(:generic_file) { Hydra::Works::GenericFile.create }
  let(:file) { generic_file.files.build }

  before do
    generic_file.files = [file]
    generic_file.save
  end

  describe "#thumbnail" do

    describe "retrieves content of the thumbnail" do
      before do
        generic_file.files.first.thumbnail = "thumbnail"
        generic_file.reload
      end
      subject { generic_file.thumbnail.first.content }
      it { is_expected.to eql "thumbnail" }
      it "retains origin pcdm.File RDF type" do
        expect(generic_file.thumbnail.first.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no thumbnail is present" do
      subject { generic_file.thumbnail }
      it { is_expected.to be_empty }
    end

  end

  describe "#original_file" do

    describe "retrieves content of the original_file" do
      before do
        generic_file.files.first.original_file = "original_file"
        generic_file.reload
      end
      subject { generic_file.original_file.first.content }
      it { is_expected.to eql "original_file" }
      it "retains origin pcdm.File RDF type" do
        expect(generic_file.original_file.first.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no original file is present" do
      subject { generic_file.original_file }
      it { is_expected.to be_empty }
    end

  end

  describe "#extracted_text" do

    describe "retrieves content of the extracted_text" do
      before do
        generic_file.files.first.extracted_text = "extracted_text"
        generic_file.reload
      end
      subject { generic_file.extracted_text.first.content }
      it { is_expected.to eql "extracted_text" }
      it "retains origin pcdm.File RDF type" do
        expect(generic_file.extracted_text.first.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no extracted text is present" do
      subject { generic_file.extracted_text }
      it { is_expected.to be_empty }
    end

  end

end
