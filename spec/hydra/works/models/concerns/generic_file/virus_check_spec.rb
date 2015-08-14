require 'spec_helper'

describe Hydra::Works::GenericFile::VirusCheck do
  before do
    class FileWithVirusCheck < ActiveFedora::Base
      include Hydra::Works::GenericFileBehavior
      include Hydra::Works::GenericFile::VirusCheck
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
end
