require 'spec_helper'

describe Hydra::Works::AddFileToGenericFile do
  let(:generic_file)        { Hydra::Works::GenericFile::Base.new }
  let(:filename)            { 'sample-file.pdf' }
  let(:filename2)           { 'updated-file.txt' }
  let(:original_name)       { 'original-name.pdf' }
  let(:file)                { File.open(File.join(fixture_path, filename)) }
  let(:file2)               { File.open(File.join(fixture_path, filename2)) }
  let(:type)                { ::RDF::URI('http://pcdm.org/use#ExtractedText') }
  let(:update_existing)     { true }
  let(:mime_type)           { 'application/pdf' }

  context 'when generic_file is not persisted' do
    let(:generic_file) { Hydra::Works::GenericFile::Base.new }
    it 'saves generic_file' do
      described_class.call(generic_file, file, type)
      expect(generic_file.persisted?).to be true
    end
  end

  context 'when generic_file is not valid' do
    before do
      generic_file.save
      allow(generic_file).to receive(:valid?).and_return(false)
    end
    it 'returns false' do
      expect(described_class.call(generic_file, file, type)).to be false
    end
  end

  context 'file responds to :mime_type and :original_name' do
    before do
      allow(file).to receive(:mime_type).and_return(mime_type)
      allow(file).to receive(:original_name).and_return(original_name)
      described_class.call(generic_file, file, type)
    end
    subject { generic_file.filter_files_by_type(type).first }
    it 'uses the mime_type and original_name methods' do
      expect(subject.mime_type).to eq(mime_type)
      expect(subject.original_name).to eq(original_name)
    end
  end

  context 'file responds to :path but not to :mime_type nor :original_name' do
    it 'defaults to Hydra::PCDM for mimetype and ::File for basename.' do
      expect(Hydra::PCDM::GetMimeTypeForFile).to receive(:call).with(file.path)
      expect(::File).to receive(:basename).with(file.path)
      described_class.call(generic_file, file, type)
    end
  end

  it 'adds the given file and applies the specified type to it' do
    described_class.call(generic_file, file, type, update_existing: update_existing)
    expect(generic_file.filter_files_by_type(type).first.content).to start_with('%PDF-1.3')
  end

  context 'when :type is the name of an association' do
    let(:type)  { :extracted_text }
    before do
      described_class.call(generic_file, file, type)
    end
    it "builds and uses the association's target" do
      expect(generic_file.extracted_text.content).to start_with('%PDF-1.3')
    end
  end

  context 'when :versioning => true' do
    let(:type)        { :original_file }
    let(:versioning)  { true }
    subject     { generic_file }
    it 'updates the file and creates a version' do
      described_class.call(generic_file, file, type, versioning: versioning)
      expect(subject.original_file.versions.all.count).to eq(1)
      expect(subject.original_file.content).to start_with('%PDF-1.3')
    end
    context 'and there are already versions' do
      before do
        described_class.call(generic_file, file, type, versioning: versioning)
        described_class.call(generic_file, file2, type, versioning: versioning)
      end
      it 'adds to the version history' do
        expect(subject.original_file.versions.all.count).to eq(2)
        expect(subject.original_file.content).to eq("some updated content\n")
      end
    end
  end

  context 'when :versioning => false' do
    let(:type)        { :original_file }
    let(:versioning)  { false }
    before do
      described_class.call(generic_file, file, type, versioning: versioning)
    end
    subject { generic_file }
    it 'skips creating versions' do
      expect(subject.original_file.versions.all.count).to eq(0)
      expect(subject.original_file.content).to start_with('%PDF-1.3')
    end
  end

  context 'type_to_uri' do
    subject { Hydra::Works::AddFileToGenericFile::Updater.allocate }
    it 'converts URI strings to RDF::URI' do
      expect(subject.send(:type_to_uri, 'http://example.com/CustomURI')).to eq(::RDF::URI('http://example.com/CustomURI'))
    end
  end
end
