require 'spec_helper'

describe Hydra::Works::AddFileToGenericFile do

  let(:generic_file)        { Hydra::Works::GenericFile::Base.create }
  let(:filename)            { "sample-file.pdf" }
  let(:path)                { File.join(fixture_path, filename) }
  let(:type)                { ::RDF::URI("http://pcdm.org/ExtractedText") }
  let(:replace)             { false }

  it "adds the given file and applies the specified type to it" do
    Hydra::Works::AddFileToGenericFile.call(generic_file, path, type, replace)
    expect(generic_file.filter_files_by_type(type).first.content).to start_with("%PDF-1.3")
  end

  context "type_to_uri" do
    it "maps supported symbols to corresponding URIs" do
      expect(Hydra::Works::AddFileToGenericFile.send(:type_to_uri, :original_file)).to eq(::RDF::URI("http://pcdm.org/OriginalFile"))
      expect(Hydra::Works::AddFileToGenericFile.send(:type_to_uri, :thumbnail)).to eq(::RDF::URI("http://pcdm.org/ThumbnailImage"))
      expect(Hydra::Works::AddFileToGenericFile.send(:type_to_uri, :extracted_text)).to eq(::RDF::URI("http://pcdm.org/ExtractedText"))
    end

    it "converts URI strings to RDF::URI" do
      expect(Hydra::Works::AddFileToGenericFile.send(:type_to_uri, "http://example.com/CustomURI" )).to eq(::RDF::URI("http://example.com/CustomURI"))
    end
  end

end