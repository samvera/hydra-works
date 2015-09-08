require 'spec_helper'

# Mocking out the Hydra::Works::GenericFile sufficiently to add original_file
# without a save to fedora. This works by mocking the response from ldp_source.head
# so AF association believes subject is already saved.
def mock_add_file_to_generic_file(gf, file)
  allow(gf.ldp_source).to receive(:head).and_return(Faraday::Response.new)
  allow(file).to receive(:has_content?).and_return(true)
  gf.original_file = file
end

# Other fits to rdf mappings
IMG_FITS_TO_RDF = { image_width:  ["imageWidth",  "toolname=Jhove"],
                    image_height: ["imageHeight", "toolname=Jhove"],
                    color_space:  ["colorSpace",  "toolname=Jhove"] }
RT_FITS_TO_RDF = { jhove_time:     ["tool", "toolname=Jhove", "executionTime"],
                   file_util_time: ["tool", "toolname=file utility", "executionTime"],
                   exiftool_time:  ["tool", "toolname=Exiftool", "executionTime"],
                   nlnz_time:      ["tool", "toolname=NLNZ Metadata Extractor", "executionTime"],
                   ois_time:       ["tool", "toolname=OIS File Information", "executionTime"],
                   ffident_time:   ["tool", "toolname=ffident", "executionTime"],
                   tika_time:      ["tool", "toolname=Tika", "executionTime"] }

describe Hydra::Works::GenericFile::Characterization do
  let(:demo_class) do
    Class.new(Hydra::Works::GenericFile::Base) do
      include Hydra::Works::GenericFile::Characterization
    end
  end

  # The is the only test context that will not mock out Characterization.characterize
  #   Remove after development as this is more of an integration test
  context "using fits.sh via Hydra::FileCharacterization" do
    let(:filename)     { 'sample-file.pdf' }
    let(:mimetype)     { 'application/pdf' }
    let(:file_content) { File.open(File.join(fixture_path, filename)) }
    let(:file)         { Hydra::PCDM::File.new.tap { |f| f.content = file_content } }
    let(:type)         { ::RDF::URI("http://pcdm.org/use#OriginalFile") }

    subject { demo_class.new(id: 'demo/01/01') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(file).to receive(:mime_type).and_return(mimetype)
      subject.original_file = file
    end

    # Simple integration test to checks that characterization runs.
    describe "Integration test using Hydra::FileCharacterziation and Fits.sh" do
      it "uses Hydra::FileCharacterization" do
        skip 'fits.sh not installed for CI environment' if ENV['TRAVIS']
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
          expect(subject.fits_version).to eq(["0.8.5"])
          expect(subject.exif_version).to eq(["9.13"])
        end

        it "has correct values in array for properties that require single values" do
          expect(subject.filename).to eq("sample-file.pdf")
          expect(subject.file_size).to eq("7618")
          expect(subject.last_modified).to eq("2015:08:07 14:49:00-04:00")
          expect(subject.date_created).to eq("2015:05:14 19:47:31Z")
          expect(subject.original_checksum).to eq("3a1735b5b30c4adc3f92c70004ae53ed")
          expect(subject.well_formed).to eq("true")
          expect(subject.valid).to eq("true")
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
        end

        it "has correct values in array for properties that require single values" do
          expect(subject.filename).to eq("sample-file.pdf")
          expect(subject.file_size).to eq("7618")
          expect(subject.last_modified).to eq("2015:08:07 14:49:00-04:00")
          expect(subject.original_checksum).to eq("3a1735b5b30c4adc3f92c70004ae53ed")
          expect(subject.well_formed).to eq("true")
          expect(subject.valid).to eq("true")
        end
      end
    end
  end # default parse_config context

  context "using custom rdf_to_fits config" do
    # Stub Hydra::FileCharacterization.characterize
    let(:characterization)     { class_double("Hydra::FileCharacterization").as_stubbed_const }
    let(:class_config)         { { nlnz_version: ["tool", "toolversion", "toolname=NLNZ Metadata Extractor"] } }
    let(:instance_config)      { { creating_app: ["creatingApplicationName", "toolname=Exiftool"] } }
    let(:fits_filename)        { 'fits_0.8.5_jp2.xml' }
    let(:fits_response)        { IO.read(File.join(fixture_path, fits_filename)) }
    let(:file)                 { Hydra::PCDM::File.new }
    let(:custom_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization
        property :image_width, predicate: ::RDF::URI.new('http://NeedAPredicate.org/ns/hydra/imageW'), multiple: false
        property :image_height, predicate: ::RDF::URI.new('http://NeedAPredicate.org/ns/hydra/imageH'), multiple: false
        property :jhove_time, predicate: ::RDF::URI.new('http://NeedAPredicate.org/ns/hydra/executionTime'), multiple: false
        parse_config.merge!(IMG_FITS_TO_RDF)
      end
    end
    let(:basic_class) do
      Class.new(Hydra::Works::GenericFile::Base) do
        include Hydra::Works::GenericFile::Characterization
      end
    end

    subject { custom_class.new(id: 'demo/02/02') }

    before do
      mock_add_file_to_generic_file(subject, file)
      allow(characterization).to receive(:characterize).and_return(fits_response)
    end

    describe "uses custom class config over default parse_config" do
      it "has a class config different from the characterization module parse_config" do
        expect(subject.class.parse_config).not_to eq(basic_class.parse_config)
      end

      it "sets class parse_config property by characterization" do
        expect(subject.image_width).to be_nil
        subject.characterize
        expect(subject.image_width).to eq("512")
      end
    end

    describe "uses custom instance parse_config over class parse_config" do
      before do
        subject.parse_config = subject.parse_config.merge(RT_FITS_TO_RDF)
      end

      it "has an instance parse_config different from the class parse_config" do
        expect(subject.parse_config).not_to eq(subject.class.parse_config)
      end

      it "gets instance parse_config property by characterization" do
        expect(subject.jhove_time).to be_nil
        subject.characterize
        expect(subject.jhove_time).to eq("722")
      end
    end
  end
end
