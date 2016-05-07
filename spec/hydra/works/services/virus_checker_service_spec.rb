require 'spec_helper'

describe Hydra::Works::VirusCheckerService do
  let(:system_virus_scanner) { double(call: nil) }
  let(:file) { Hydra::PCDM::File.new { |f| f.content = File.new(File.join(fixture_path, 'sample-file.pdf')) } }
  let(:virus_checker) { described_class.new(file, system_virus_scanner) }

  context '.file_has_virus?' do
    it 'is a convenience method' do
      mock_object = double(file_has_virus?: true)
      allow(described_class).to receive(:new).and_return(mock_object)
      described_class.file_has_virus?(file)
      expect(mock_object).to have_received(:file_has_virus?)
    end
  end

  context 'with a system virus scanner that did not run' do
    let(:virus_checker) { described_class.new(file) }
    it 'will return false and set a system warning' do
      expect(defined?(ClamAV)).to eq(nil) # A bit of a sanity test to make sure the default behaves
      allow(file).to receive(:path).and_return('/tmp/file.pdf')
      expect(virus_checker).to receive(:warning).with(kind_of(String))
      expect(virus_checker.file_has_virus?).to eq(true)
    end
  end

  context 'with an infected file' do
    context 'that responds to :path' do
      it 'will return false' do
        expect(system_virus_scanner).to receive(:call).with('/tmp/file.pdf').and_return(1)
        allow(file).to receive(:path).and_return('/tmp/file.pdf')
        expect(virus_checker.file_has_virus?).to eq(true)
      end
    end
    context 'that does not respond to :path' do
      it 'will return false' do
        expect(system_virus_scanner).to receive(:call).with(kind_of(String)).and_return(1)
        allow(file).to receive(:respond_to?).and_call_original
        allow(file).to receive(:respond_to?).with(:path).and_return(false)
        expect(virus_checker.file_has_virus?).to eq(true)
      end
    end
  end

  context 'with a clean file' do
    context 'that responds to :path' do
      it 'will return true' do
        expect(system_virus_scanner).to receive(:call).with('/tmp/file.pdf').and_return(0)
        allow(file).to receive(:path).and_return('/tmp/file.pdf')
        expect(virus_checker.file_has_virus?).to eq(false)
      end
    end
    context 'that does not respond to :path' do
      it 'will return true' do
        expect(system_virus_scanner).to receive(:call).with(kind_of(String)).and_return(0)
        allow(file).to receive(:respond_to?).and_call_original
        allow(file).to receive(:respond_to?).with(:path).and_return(false)
        expect(virus_checker.file_has_virus?).to eq(false)
      end
    end
  end

  context '#default_system_virus_scanner' do
    let(:virus_checker) { described_class.new(file) }
    let(:system_virus_scanner) { virus_checker.send(:default_system_virus_scanner) }
    it 'is callable' do
      expect(system_virus_scanner).to respond_to(:call)
    end
    context 'when called and ClamAV is NOT defined' do
      it 'will warn and return :no_anti_virus_was_run if ClamAV is not defined' do
        expect(system_virus_scanner.call('/tmp/path')).to eq(:no_anti_virus_was_run)
      end
    end
    context 'when called and ClamAV is defined' do
      before do
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
      end
      it "will call the Clam's scanfile" do
        expect(ClamAV.instance).to receive(:scanfile).with('/tmp/path')
        system_virus_scanner.call('/tmp/path')
      end
    end
  end
end
