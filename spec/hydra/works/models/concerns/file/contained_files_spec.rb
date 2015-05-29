require 'spec_helper'

describe Hydra::Works::GenericFile::ContainedFiles do

  let(:generic_file) do
    Hydra::Works::GenericFile::Base.create
  end

  let(:file) { generic_file.files.build }

  before do
    generic_file.files = [file]
    generic_file.save
  end

  describe "#thumbnail" do

    describe "retrieves content of the thumbnail" do
      before do
        generic_file.files.last.content = "thumbnail"

        # Workaround for adding multiple RDF types to a file
        t = generic_file.files.last.metadata_node.get_values(:type)
        t << ::RDF::URI("http://pcdm.org/ThumbnailImage")
        generic_file.files.last.metadata_node.set_value(:type,t)

        generic_file.save
      end
      subject { generic_file.thumbnail.content }
      it { is_expected.to eql "thumbnail" }
      it "retains origin pcdm.File RDF type" do
        expect(generic_file.thumbnail.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no thumbnail is present" do
      subject { generic_file.thumbnail }
      it { is_expected.to be_nil }
    end

  end

  describe "#original_file" do

    describe "retrieves content of the original_file" do
      before do
        generic_file.files.last.content = "original_file"

        # Workaround for adding multiple RDF types to a file
        t = generic_file.files.last.metadata_node.get_values(:type)
        t << ::RDF::URI("http://pcdm.org/OriginalFile")
        generic_file.files.last.metadata_node.set_value(:type,t)

        generic_file.save
      end
      subject { generic_file.original_file.content }
      it { is_expected.to eql "original_file" }
      it "retains origin pcdm.File RDF type" do
        expect(generic_file.original_file.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no original file is present" do
      subject { generic_file.original_file }
      it { is_expected.to be_nil }
    end

  end

  describe "#extracted_text" do

    describe "retrieves content of the extracted_text" do
      before do
        generic_file.files.last.content = "extracted_text"

        # Workaround for adding multiple RDF types to a file
        t = generic_file.files.last.metadata_node.get_values(:type)
        t << ::RDF::URI("http://pcdm.org/ExtractedText")
        generic_file.files.last.metadata_node.set_value(:type,t)

        generic_file.save
      end
      subject { generic_file.extracted_text.content }
      it { is_expected.to eql "extracted_text" }
      it "retains origin pcdm.File RDF type" do
        expect(generic_file.extracted_text.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no extracted text is present" do
      subject { generic_file.extracted_text }
      it { is_expected.to be_nil }
    end

  end

end
