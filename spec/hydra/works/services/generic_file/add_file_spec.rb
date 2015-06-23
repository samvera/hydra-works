require 'spec_helper'

describe Hydra::Works::AddFileToGenericFile do

  let(:generic_file)        { Hydra::Works::GenericFile::Base.create }
  let(:reloaded)            { generic_file.reload }
  let(:filename)            { "sample-file.pdf" }
  let(:path)                { File.join(fixture_path, filename) }
  let(:path2)               { File.join(fixture_path, "updated-file.txt") }
  let(:type)                { ::RDF::URI("http://pcdm.org/ExtractedText") }
  let(:update_existing)     { true }

  it "adds the given file and applies the specified type to it" do
    Hydra::Works::AddFileToGenericFile.call(generic_file, path, type, update_existing)
    expect(generic_file.filter_files_by_type(type).first.content).to start_with("%PDF-1.3")
  end

  context "when :type is the name of an association" do
    let(:type)  { :extracted_text }
    before do
      Hydra::Works::AddFileToGenericFile.call(generic_file, path, type)
    end
    it "builds and uses the association's target" do
      expect(reloaded.extracted_text.content).to start_with("%PDF-1.3")
    end
  end

  context "when the file is versionable" do
    let(:type)  { :original_file }
    subject     { reloaded }
    before do
      Hydra::Works::AddFileToGenericFile.call(generic_file, path, type)
    end
    it "updates the file and creates a version" do
      expect(subject.original_file.versions.all.count).to eq(1)
      expect(subject.original_file.content).to start_with("%PDF-1.3")
    end
    context "and there are already versions" do
      before do
        Hydra::Works::AddFileToGenericFile.call(generic_file, path2, type)
      end
      it "adds to the version history" do
        expect(subject.original_file.versions.all.count).to eq(2)
        expect(subject.original_file.content).to eq("some updated content\n")
      end
    end
  end

  context "type_to_uri" do
    it "converts URI strings to RDF::URI" do
      expect(Hydra::Works::AddFileToGenericFile.send(:type_to_uri, "http://example.com/CustomURI" )).to eq(::RDF::URI("http://example.com/CustomURI"))
    end
  end

end