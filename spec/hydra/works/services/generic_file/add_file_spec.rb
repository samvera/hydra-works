require 'spec_helper'

describe Hydra::Works::AddFileToGenericFile do

  let(:generic_file)        { Hydra::Works::GenericFile::Base.create }
  let(:reloaded)            { generic_file.reload }
  let(:filename)            { "sample-file.pdf" }
  let(:path)                { File.join(fixture_path, filename) }
  let(:path2)               { File.join(fixture_path, "updated-file.txt") }
  let(:type)                { ::RDF::URI("http://pcdm.org/use#ExtractedText") }
  let(:update_existing)     { true }

  context "when generic_file is not persisted" do
    let(:generic_file)        { Hydra::Works::GenericFile::Base.new }
    it "saves generic_file" do
      described_class.call(generic_file, path, type)
      expect(generic_file.persisted?).to be true
    end
  end

  context "when you provide mime_type and original_name" do
    before { described_class.call(generic_file, path, type, mime_type: "image/png", original_name:'chosen_filename.txt') }
    subject { generic_file.filter_files_by_type(type).first }
    it "uses the provided values" do
      expect(subject.mime_type).to eq('image/png')
      expect(subject.original_name).to eq('chosen_filename.txt')
    end
  end

  it "adds the given file and applies the specified type to it" do
    described_class.call(generic_file, path, type, update_existing: update_existing)
    expect(generic_file.filter_files_by_type(type).first.content).to start_with("%PDF-1.3")
  end

  context "when :type is the name of an association" do
    let(:type)  { :extracted_text }
    before do
      described_class.call(generic_file, path, type)
    end
    it "builds and uses the association's target" do
      expect(reloaded.extracted_text.content).to start_with("%PDF-1.3")
    end
  end

  context "when :versioning => true" do
    let(:type)        { :original_file }
    let(:versioning)  { true }
    subject     { reloaded }
    it "updates the file and creates a version" do
      described_class.call(generic_file, path, type, versioning: versioning)
      expect(subject.original_file.versions.all.count).to eq(1)
      expect(subject.original_file.content).to start_with("%PDF-1.3")
    end
    context "and there are already versions" do
      before do
        described_class.call(generic_file, path, type, versioning: versioning)
        described_class.call(generic_file, path2, type, versioning: versioning)
      end
      it "adds to the version history" do
        expect(subject.original_file.versions.all.count).to eq(2)
        expect(subject.original_file.content).to eq("some updated content\n")
      end
    end
  end

  context "when :versioning => false" do
    let(:type)        { :original_file }
    let(:versioning)  { false }
    before do
      described_class.call(generic_file, path, type, versioning: versioning)
    end
    subject     { reloaded }
    it "skips creating versions" do
      expect(subject.original_file.versions.all.count).to eq(0)
      expect(subject.original_file.content).to start_with("%PDF-1.3")
    end
  end

  context "type_to_uri" do
    it "converts URI strings to RDF::URI" do
      expect(described_class.send(:type_to_uri, "http://example.com/CustomURI" )).to eq(::RDF::URI("http://example.com/CustomURI"))
    end
  end

end