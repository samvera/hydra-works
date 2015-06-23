require 'spec_helper'

describe Hydra::Works::GenericFile::VersionedContent do
  let(:generic_file)  { Hydra::Works::GenericFile::Base.create }
  let(:reloaded)      { generic_file.reload }
  before do
    Hydra::Works::UploadFileToGenericFile.call(generic_file, File.join(fixture_path, "sample-file.pdf"))
    Hydra::Works::UploadFileToGenericFile.call(generic_file, File.join(fixture_path, "updated-file.txt"))
  end

  describe "content_versions" do
    subject {reloaded.content_versions}
    it "lists all of the versions of original_file" do
      expect(subject.count).to eq(2)
      expect(subject.map { |v| v.uri }).to eq(reloaded.original_file.versions.all.map { |v| v.uri })
    end
  end

  describe "latest_content_version" do
    it "returns the most recent version of original_file" do
      expect(reloaded.latest_content_version.content).to eq("some updated content\n")
    end
  end

  describe "current_content_version_uri" do
    it "returns the URI of the most recent version of original_file" do
      expect(generic_file.current_content_version_uri).to eq(generic_file.original_file.versions.last.uri)
    end
  end
end