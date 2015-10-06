require 'spec_helper'
require 'support/generic_file_helper'

describe Hydra::Works::CharacterizationService do
  let(:demo_class) do
    Class.new(Hydra::Works::FileSet) do
      include Hydra::Works::Characterization
    end
  end

  describe "integration test for characterizing from path on disk." do
    let(:filename)           { 'sample-file.pdf' }
    let(:path_on_disk)       { File.join(fixture_path, filename) }
    let(:generic_file)       { demo_class.new(id: 'inte/gr/at/ion') }

    it 'sets expected properties on the object' do
      skip 'external tools not installed for CI environment' if ENV['CI']
      described_class.run(generic_file, path_on_disk)
      expect(generic_file.file_size).to eq(["7618"])
      expect(generic_file.title).to eq(["sample-file"])
      expect(generic_file.page_count).to eq(["1"])
    end
  end

  describe "handling symbols, strings, and files as sources" do
    # Stub Hydra::FileCharacterization.characterize
    let(:characterization)   { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_filename)      { 'fits_0.8.5_pdf.xml' }
    let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
    let(:filename)           { 'sample-file.pdf' }
    let(:file_content)       { IO.read(File.join(fixture_path, filename)) }
    let(:file)               { Hydra::PCDM::File.new { |f| f.content = file_content } }
    let(:generic_file)       { demo_class.new(id: 'demo/ch/12/on') }

    before do
      mock_add_file_to_generic_file(generic_file, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    context "using default Symbol as the source." do
      it 'calls the corresponding method of the object.' do
        expect(generic_file).to receive(:original_file)
        described_class.run(generic_file)
      end

      it 'passes the content to characterization.' do
        expect(Hydra::FileCharacterization).to receive(:characterize).with(file_content, any_args)
        described_class.run(generic_file)
      end
    end

    context "using a string path as the source." do
      it 'passes a file with the string as a path to FileCharacterization.' do
        path_on_disk = File.join(fixture_path, filename)
        expect(Hydra::FileCharacterization).to receive(:characterize).with(kind_of(File), any_args)
        described_class.run(generic_file, path_on_disk)
      end
    end

    context "using a File instance as the source." do
      it 'passes the File to FileCharacterization.' do
        file_inst = File.new(File.join(fixture_path, filename))
        expect(Hydra::FileCharacterization).to receive(:characterize).with(file_inst, any_args)
        described_class.run(generic_file, file_inst)
      end
    end
  end

  context "passing an object that does not have matching properties" do
    # Stub Hydra::FileCharacterization.characterize
    let(:characterization) { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:bland_class) do
      Class.new(Hydra::Works::FileSet) { include Hydra::Works::Characterization }
    end
    let(:fits_filename)      { 'fits_0.8.5_pdf.xml' }
    let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
    let(:file_content)       { 'dummy content' }
    let(:file)               { Hydra::PCDM::File.new { |f| f.content = file_content } }
    let(:generic_file) { bland_class.new(id: 'base/ch/12/on') }

    before do
      mock_add_file_to_generic_file(generic_file, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    it 'does not explode with an error.' do
      expect { described_class.run(generic_file) }.to_not raise_error
    end
  end

  describe 'assigned properties.' do
    # Stub Hydra::FileCharacterization.characterize
    let(:characterization) { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:file)               { Hydra::PCDM::File.new }
    let(:generic_file)       { demo_class.new(id: 'prop/er/ti/es') }

    before do
      mock_add_file_to_generic_file(generic_file, file)
    end

    context 'using document metadata' do
      let(:fits_filename)      { 'fits_0.8.5_pdf.xml' }
      let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }

      before do
        allow(characterization).to receive(:characterize).and_return(fits_response)
        described_class.run(generic_file)
      end

      it 'assigns expected values to document properties.' do
        expect(generic_file.title).to eq(["sample-file"])
        expect(generic_file.page_count).to eq(["1"])
      end
    end

    context 'using image metadata' do
      let(:fits_filename)      { 'fits_0.8.5_jp2.xml' }
      let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
      before do
        allow(characterization).to receive(:characterize).and_return(fits_response)
        described_class.run(generic_file)
      end
      it 'assigns expected values to image properties.' do
        expect(generic_file.file_size).to eq(["11043"])
        expect(generic_file.byte_order).to eq("big endian")
        expect(generic_file.compression).to eq("JPEG 2000")
        expect(generic_file.width).to eq(["512"])
        expect(generic_file.height).to eq(["465"])
        expect(generic_file.color_space).to eq("sRGB")
      end
    end
    context 'using video metadata' do
      let(:fits_filename)      { 'fits_0.8.5_avi.xml' }
      let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
      before do
        allow(characterization).to receive(:characterize).and_return(fits_response)
        described_class.run(generic_file)
      end
      it 'assigns expected values to video properties.' do
        expect(generic_file.height).to eq(["264"])
        expect(generic_file.width).to eq(["356"])
        expect(generic_file.duration).to eq(["14.10 s"])
        expect(generic_file.frame_rate).to eq(["10"])
        expect(generic_file.sample_rate).to eq(["11025"])
      end
    end
    context 'using audio metadata' do
      let(:fits_filename)      { 'fits_0.8.5_mp3.xml' }
      let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
      before do
        allow(characterization).to receive(:characterize).and_return(fits_response)
        described_class.run(generic_file)
      end
      it 'assigns expected values to audio properties.' do
        expect(generic_file.mime_type).to eq("audio/mpeg")
        expect(generic_file.duration).to eq(["0:0:15:261"])
        expect(generic_file.sample_rate).to eq(["44100"])
      end
    end
  end
end
