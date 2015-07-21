require 'spec_helper'

describe Hydra::Works::UploadFileToGenericFile do

  let(:generic_work)        { Hydra::Works::GenericWork::Base.new }
  let(:generic_file)        { Hydra::Works::GenericFile::Base.new }
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
      subject { generic_file }
      it "has content and generated files" do
        expect(subject.original_file.content).to start_with("%PDF-1.3")
        expect(subject.original_file.mime_type).to eql mime_type
        expect(subject.original_file.original_name).to eql filename
        expect(subject.thumbnail.content).not_to be_nil
      end
    end
  end

  context "when updating an existing file" do
    let(:additional_services) { [] }

    before do
      described_class.call(generic_file, file, additional_services: additional_services)
      described_class.call(generic_file, updated_file, additional_services: additional_services, update_existing: true)
    end

    describe "the new file" do
      subject { generic_file.original_file }
      it "has updated content" do
        expect(subject.content).to eql File.open(updated_file).read
        expect(subject.original_name).to eql updated_filename
        expect(subject.mime_type).to eql updated_mime_type
        expect(subject.versions.all.count).to eql 2
      end
    end
  end

end
  
