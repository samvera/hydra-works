require 'spec_helper'
require 'support/generic_file_helper'

describe Hydra::Works::GenericFile::Characterization do
  let(:demo_class) do
    Class.new(Hydra::Works::GenericFile::Base) do
      include Hydra::Works::GenericFile::Characterization
    end
  end

  context "using fits.sh via Hydra::FileCharacterization" do
    let(:filename)     { 'sample-file.pdf' }
    let(:mimetype)     { 'application/pdf' }
    let(:file_content) { File.open(File.join(fixture_path, filename)) }
    let(:file)         { Hydra::PCDM::File.new { |f| f.content = file_content } }
    let(:type)         { ::RDF::URI("http://pcdm.org/use#OriginalFile") }

    subject { demo_class.new(id: 'demo/01/01') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(file).to receive(:mime_type).and_return(mimetype)
      subject.original_file = file
    end

    # Simple integration test to check that characterization runs.
    describe "Integration test using Hydra::FileCharacterziation and Fits.sh" do
      it "uses Hydra::FileCharacterization" do
        skip 'fits.sh not installed for CI environment' if ENV['CI']
        expect(subject.characterize).not_to be_nil
      end
    end
  end

  context "using default parsing mapping" do
    # Stub Hydra::FileCharacterization.characterize
    let(:characterization) { class_double("Hydra::FileCharacterization").as_stubbed_const }

    subject { demo_class.new(id: 'demo/de/fa/lt/ma/ping') }

    context "using fits.sh version 0.8.5 response for pdf" do
      let(:fits_filename)      { 'fits_0.8.5_pdf.xml' }
      let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
      let(:file)               { Hydra::PCDM::File.new }

      before do
        mock_add_file_to_generic_file(subject, file)
        allow(characterization).to receive(:characterize).and_return(fits_response)
        subject.characterize
      end

      describe "content characterization parsed to properties" do
        it "has correct values in array for properties that permit multiple values" do
          expect(subject.original_checksum).to eq(["3a1735b5b30c4adc3f92c70004ae53ed"])
          expect(subject.fits_version).to eq(["0.8.5"])
          expect(subject.exif_version).to eq(["9.13"])
          expect(subject.file_size).to eq(["7618"])
          expect(subject.last_modified).to eq(["2015:08:07 14:49:00-04:00"])
          expect(subject.date_created).to eq(["2015:05:14 19:47:31Z"])
          expect(subject.well_formed).to eq(["true"])
          expect(subject.valid).to eq(["true"])
        end

        it "has correct values in array for properties that require single values" do
          expect(subject.filename).to eq("sample-file.pdf")
          expect(subject.mime_type).to eq("application/pdf")
        end
      end
    end

    context "using fits.sh version 0.6.2" do
      let(:fits_filename)      { 'fits_0.6.2_pdf.xml' }
      let(:fits_response)      { IO.read(File.join(fixture_path, fits_filename)) }
      let(:file)               { Hydra::PCDM::File.new }

      before do
        mock_add_file_to_generic_file(subject, file)
        allow(characterization).to receive(:characterize).and_return(fits_response)
        subject.characterize
      end

      describe "content characterization parsed to properties" do
        it "has correct values in array for properties that permit multiple values" do
          expect(subject.fits_version).to eq(["0.6.2"])
          expect(subject.exif_version).to eq(["9.06"])
          expect(subject.file_size).to eq(["7618"])
          expect(subject.last_modified).to eq(["2015:08:07 14:49:00-04:00"])
          expect(subject.original_checksum).to eq(["3a1735b5b30c4adc3f92c70004ae53ed"])
          expect(subject.well_formed).to eq(["true"])
          expect(subject.valid).to eq(["true"])
        end

        it "has correct values in array for properties that require single values" do
          expect(subject.filename).to eq("sample-file.pdf")
          expect(subject.mime_type).to eq("application/pdf")
        end
      end
    end
  end

  context "using image module" do
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_filename)        { 'fits_0.8.5_jp2.xml' }
    let(:fits_response)        { IO.read(File.join(fixture_path, fits_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:demo_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization::Base
        include Hydra::Works::GenericFile::Characterization::Image
      end
    end

    subject { demo_class.new(id: 'demo/02/02') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    it "has expected values for added properties" do
      subject.characterize

      expect(subject.file_size).to eq(["11043"])
      expect(subject.byte_order).to eq("big endian")
      expect(subject.compression).to eq("JPEG 2000")
      expect(subject.width).to eq(["512"])
      expect(subject.height).to eq(["465"])
      expect(subject.color_space).to eq("sRGB")
    end
  end

  context "using video module" do
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_filename)        { 'fits_0.8.5_avi.xml' }
    let(:fits_response)        { IO.read(File.join(fixture_path, fits_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:demo_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization::Base
        include Hydra::Works::GenericFile::Characterization::Video
      end
    end

    subject { demo_class.new(id: 'demo/03/03') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    it "has expected values for added properties" do
      subject.characterize

      expect(subject.height).to eq(["264"])
      expect(subject.width).to eq(["356"])
      expect(subject.duration).to eq(["14.10 s"])
      expect(subject.frame_rate).to eq(["10"])
      expect(subject.sample_rate).to eq(["11025"])
    end
  end

  context "using audio module" do
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_filename)        { 'fits_0.8.5_mp3.xml' }
    let(:fits_response)        { IO.read(File.join(fixture_path, fits_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:demo_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization::Base
        include Hydra::Works::GenericFile::Characterization::Audio
      end
    end

    subject { demo_class.new(id: 'demo/04/04') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    it "has expected values for added properties" do
      subject.characterize

      expect(subject.mime_type).to eq("audio/mpeg")
      expect(subject.duration).to eq(["0:0:15:261"])
      expect(subject.sample_rate).to eq(["44100"])
    end
  end

  context "using document module" do
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_filename)        { 'fits_0.8.5_pdf.xml' }
    let(:fits_response)        { IO.read(File.join(fixture_path, fits_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:demo_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization::Base
        include Hydra::Works::GenericFile::Characterization::Document
      end
    end

    subject { demo_class.new(id: 'demo/04/04') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    it "has expected values for added properties" do
      subject.characterize

      expect(subject.title).to eq(["sample-file"])
      expect(subject.page_count).to eq(["1"])
    end
  end

  context "using two modules: image and video" do
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_image_filename)  { 'fits_0.8.5_jp2.xml' }
    let(:fits_video_filename)  { 'fits_0.8.5_mp4.xml' }
    let(:fits_image_response)  { IO.read(File.join(fixture_path, fits_image_filename)) }
    let(:fits_video_response)  { IO.read(File.join(fixture_path, fits_video_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:demo_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization::Base
        include Hydra::Works::GenericFile::Characterization::Image
        include Hydra::Works::GenericFile::Characterization::Video
      end
    end
    let(:image_containing) { demo_class.new(id: 'demo/05/05') }
    let(:video_containing) { demo_class.new(id: 'demo/06/06') }

    before do
      mock_add_file_to_generic_file(image_containing, file)
      mock_add_file_to_generic_file(video_containing, file)
    end

    it "assigns properties property for modlues with overlapping predicates" do
      allow(characterization).to receive(:characterize).and_return(fits_image_response)
      image_containing.characterize
      allow(characterization).to receive(:characterize).and_return(fits_video_response)
      video_containing.characterize

      expect(image_containing.height).to eq(["465"])
      expect(image_containing.width).to eq(["512"])
      expect(video_containing.height).to eq(["240"])
      expect(video_containing.width).to eq(["190"])
    end
  end

  context "using two modules: video and audio" do
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:fits_audio_filename)  { 'fits_0.8.5_mp3.xml' }
    let(:fits_video_filename)  { 'fits_0.8.5_mp4.xml' }
    let(:fits_audio_response)  { IO.read(File.join(fixture_path, fits_audio_filename)) }
    let(:fits_video_response)  { IO.read(File.join(fixture_path, fits_video_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:demo_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization::Base
        include Hydra::Works::GenericFile::Characterization::Video
        include Hydra::Works::GenericFile::Characterization::Audio
      end
    end
    let(:audio_containing) { demo_class.new(id: 'demo/05/05') }
    let(:video_containing) { demo_class.new(id: 'demo/06/06') }

    before do
      mock_add_file_to_generic_file(audio_containing, file)
      mock_add_file_to_generic_file(video_containing, file)
    end

    it "assigns properties property for modlues with overlapping predicates" do
      allow(characterization).to receive(:characterize).and_return(fits_audio_response)
      audio_containing.characterize
      allow(characterization).to receive(:characterize).and_return(fits_video_response)
      video_containing.characterize

      expect(audio_containing.duration).to eq(["0:0:15:261"])
      expect(video_containing.duration).to eq(["4.97 s"])
      expect(audio_containing.sample_rate).to eq(["44100"])
      expect(video_containing.sample_rate).to eq(["32000"])
    end
  end
end
