require 'spec_helper'

describe Hydra::Works::AddOriginalFile do

  let(:generic_work)        { Hydra::Works::GenericWork::Base.create }
  let(:generic_file)        { Hydra::Works::GenericFile::Base.create }
  let(:file)                { File.open(File.join(fixture_path, "sample-file.pdf")) }
  let(:other_file)          { File.open(File.join(fixture_path, "updated-file.txt")) }
  
  context "object is not a generic file" do
    let(:error_message) { "supplied object must be a generic file" }
    it "raises an error" do
      expect( lambda { described_class.call(generic_work, file) } ).to raise_error(ArgumentError, error_message)
    end
  end

  context "file is not a ::File nor ::IO" do
    let(:error_message) { "supplied file must respond to read" }
    let(:not_a_file) { Object.new }
    it "raises an error" do
      expect( lambda { described_class.call(generic_file, not_a_file) } ).to raise_error(ArgumentError, error_message)
    end
  end

  context "a readable file is added without options" do
    before { described_class.call(generic_file, file) }

    describe "the added file" do
      subject { generic_file.original_file }
      it "has content" do
        expect(subject.content).to start_with("%PDF-1.3")
      end
      it "has default mime_type" do
        expect(subject.mime_type).to eq('text/plain')
      end
      it "has blank original_name" do
        expect(subject.original_name).to eq('')
      end
    end
  end

  context "descriptive options are supplied" do
    let(:mime_type) {"application/json"}
    let(:original_name) {"original.txt"}
    before { described_class.call(generic_file, file, original_name: original_name, mime_type: mime_type) }

    describe "the added file" do
      subject { generic_file.original_file }
      it "has mime_type" do
        expect(subject.mime_type).to eq(mime_type)
      end
      it "has original_name" do
        expect(subject.original_name).to eq(original_name)
      end
    end
  end

  context "two files are added" do
    context "replace option is true" do
      before do 
        described_class.call(generic_file, file) 
        described_class.call(generic_file, other_file, replace: true) 
      end
    end

    context "replace option is not specified" do
      before do
        described_class.call(generic_file, file) 
        described_class.call(generic_file, other_file) 
      end
    end
  end




end
