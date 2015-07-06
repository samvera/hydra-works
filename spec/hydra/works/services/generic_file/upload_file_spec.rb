require 'spec_helper'

describe Hydra::Works::UploadFileToGenericFile do

  let(:generic_work)        { Hydra::Works::GenericWork::Base.create }
  let(:generic_file)        { Hydra::Works::GenericFile::Base.create }
  let(:filename)            { "sample-file.pdf" }
  let(:file)                { File.join(fixture_path, filename) }
  let(:updated_filename)    { "updated-file.txt"}
  let(:updated_file)        { File.join(fixture_path, updated_filename) }
  let(:mime_type)           { "application/pdf" }
  let(:original_name)       { "my_original.pdf" }
  let(:updated_mime_type)   { "text/plain" }
  let(:additional_services) { [Hydra::Works::GenerateThumbnail] }

  context "when you provide mime_type and original_name, etc" do
    it "uses the provided values" do
      expect(Hydra::Works::AddFileToGenericFile).to receive(:call).with(generic_file, file, :original_file, update_existing: true, versioning: true, mime_type:mime_type, original_name:original_name)
      described_class.call(generic_file, file, mime_type: mime_type, original_name:original_name)
    end
  end

  context "without a proper generic file" do
    let(:error_message) { "supplied object must be a generic file" }
    it "raises an error" do
      expect( lambda { described_class.call(generic_work, file) }).to raise_error(ArgumentError, error_message)
    end
  end

  context "without a proper path" do
    let(:error_message) { "supplied path must be a string" }
    it "raises an error" do
      expect( lambda { described_class.call(generic_file, ["this isn't a path"]) }).to raise_error(ArgumentError, error_message)
    end
  end

  context "with a non-existent file" do
    let(:error_message) { "supplied path to file does not exist" }
    it "raises an error" do
      expect( lambda { described_class.call(generic_file, "/i/do/not/exist") }).to raise_error(ArgumentError, error_message)
    end
  end

  context "with an empty generic file" do
    before { described_class.call(generic_file, file, additional_services: additional_services) }

    describe "the uploaded file" do
      subject { generic_file.original_file }
      it "has content" do
        expect(subject.content).to start_with("%PDF-1.3")
      end
      it "has a mime type" do
        expect(subject.mime_type).to eql mime_type
      end
      it "has a name" do
        expect(subject.original_name).to eql filename
      end
    end

    describe "the generic file's generated files" do
      subject { generic_file }
      it "has a thumbnail" do
        expect(subject.thumbnail.content).not_to be_nil
      end
    end
  end

  context "when updating an existing file" do
    let(:additional_services) { [] }

    before do
      described_class.call(generic_file, file, additional_services: additional_services)
      described_class.call(generic_file, updated_file, additional_services: additional_services, update_existing: true)
      generic_file.reload
    end

    describe "the new file" do
      subject { generic_file.original_file }
      it "has updated content" do
        expect(subject.content).to eql File.open(updated_file).read
      end
      it "has an updated name" do
        expect(subject.original_name).to eql updated_filename
      end
      it "has a updated mime type" do
        expect(subject.mime_type).to eql updated_mime_type
      end
      it "has 2 versions in its history" do
        expect(subject.versions.all.count).to eql 2
      end
    end
  end

end
  