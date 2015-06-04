require 'spec_helper'

describe Hydra::Works::GenericFile::ContainedFiles do

  let(:generic_file) do
    Hydra::Works::GenericFile::Base.create
  end

  let(:thumbnail)   do
    file = generic_file.files.build
    Hydra::PCDM::AddTypeToFile.call(file, pcdm_thumbnail_uri)
  end

  let(:file)                { generic_file.files.build }
  let(:pcdm_thumbnail_uri)  { ::RDF::URI("http://pcdm.org/ThumbnailImage") }

  before do
    generic_file.files = [file]
    generic_file.save
  end

  describe "#thumbnail" do

    context "when a thumbnail is present" do
      before do
        generic_file.thumbnail.content = "thumbnail"
      end
      subject { generic_file.thumbnail }
      it "can be saved without errors" do
        expect(subject.save).to be_truthy
      end
      it "retrieves content of the thumbnail" do
        expect(subject.content).to eql "thumbnail"
      end
      it "retains origin pcdm.File RDF type" do
        expect(subject.metadata_node.type).to include( ::RDF::URI("http://pcdm.org/ThumbnailImage") )
        expect(subject.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no thumbnail is present" do
      subject { generic_file.thumbnail }
      it "initializes an unsaved File object with Thumbnail type" do
        expect(subject).to be_new_record
        expect(subject.metadata_node.type).to include(pcdm_thumbnail_uri)
        expect(subject.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

  end

  describe "#original_file" do

    context "when an original file is present" do
      before do
        generic_file.original_file.content = "original_file"
      end
      subject { generic_file.original_file }

      it "can be saved without errors" do
        expect(subject.save).to be_truthy
      end
      it "retrieves content of the original_file" do
        expect(subject.content).to eql "original_file"
      end
      it "retains origin pcdm.File RDF type" do
        expect(subject.metadata_node.type).to include(::RDF::URI("http://pcdm.org/OriginalFile") )
        expect(generic_file.original_file.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no original file is present" do
      subject { generic_file.original_file }
      it "initializes an unsaved File object with OrignalFile type" do
        expect(subject).to be_new_record
        expect(subject.metadata_node.type).to include(::RDF::URI("http://pcdm.org/OriginalFile") )
        expect(subject.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

  end

  describe "#extracted_text" do

    context "when extracted text is present" do
      before do
        generic_file.extracted_text.content = "extracted_text"
      end
      subject { generic_file.extracted_text }
      it "can be saved without errors" do
        expect(subject.save).to be_truthy
      end
      it "retrieves content of the extracted_text" do
        expect(subject.content).to eql "extracted_text"
      end
      it "retains origin pcdm.File RDF type" do
        expect(subject.metadata_node.type).to include(::RDF::URI("http://pcdm.org/ExtractedText") )
        expect(subject.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

    context "when no extracted text is present" do
      subject { generic_file.extracted_text }
      it "initializes an unsaved File object with ExtractedText type" do
        expect(subject).to be_new_record
        expect(subject.metadata_node.type).to include(::RDF::URI("http://pcdm.org/ExtractedText") )
        expect(subject.metadata_node.type).to include(RDFVocabularies::PCDMTerms.File)
      end
    end

  end

end
