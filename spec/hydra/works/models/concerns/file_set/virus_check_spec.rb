require 'spec_helper'

describe Hydra::Works::VirusCheck do
  context "with ClamAV" do
    before do
      class FileWithVirusCheck < ActiveFedora::Base
        include Hydra::Works::FileSetBehavior
        include Hydra::Works::VirusCheck
      end
      class ClamAV
        def self.instance
          @instance ||= ClamAV.new
        end

        def scanfile(path)
          puts "scanfile: #{path}"
        end
      end
    end
    after do
      Object.send(:remove_const, :ClamAV)
      Object.send(:remove_const, :FileWithVirusCheck)
    end

    subject { FileWithVirusCheck.new }
    let(:file) { Hydra::PCDM::File.new File.join(fixture_path, 'sample-file.pdf') }

    before do
      allow(subject).to receive(:original_file) { file }
      allow(subject).to receive(:warn) # suppress virus warning messages
    end

    context 'with an infected file' do
      before do
        expect(ClamAV.instance).to receive(:scanfile).and_return(1)
      end
      it 'fails to save' do
        expect(subject.save).to eq false
      end
      it 'fails to validate' do
        expect(subject.validate).to eq false
      end
    end

    context 'with a clean file' do
      before do
        expect(ClamAV.instance).to receive(:scanfile).and_return(0)
      end

      it 'does not detect viruses' do
        expect(subject.detect_viruses).to eq true
      end
    end

    context 'with a file that responds to :path' do
      before do
        allow(file).to receive(:path).and_return('/tmp/file.pdf')
      end

      it 'gets the filename from :path' do
        expect(subject.send(:local_path_for_file, file)).to eq('/tmp/file.pdf')
      end
    end
  end

  context "Without ClamAV" do
    before do
      class FileWithVirusCheck < ActiveFedora::Base
        include Hydra::Works::FileSetBehavior
        include Hydra::Works::VirusCheck
      end
      Object.send(:remove_const, :ClamAV) if defined?(ClamAV)
    end

    subject { FileWithVirusCheck.new }
    let(:file) { Hydra::PCDM::File.new File.join(fixture_path, 'sample-file.pdf') }

    before do
      allow(subject).to receive(:original_file) { file }
    end

    it 'warns if ClamAV is not defined' do
      expect(subject).to receive(:warning) # .with("Virus checking disabled, sample-file.pdf not checked")
      expect(subject.detect_viruses).to eq nil
    end
  end
end
