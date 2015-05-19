require 'spec_helper'

describe Hydra::Works::GetMimeTypeForFile do

  context "with faulty input" do
    let(:error_message) { "supplied argument should be a path to a file" }
    it "raises and error" do
      expect( lambda{described_class.call(["bad input"])}).to raise_error(ArgumentError, error_message)
    end
  end

  context "with a standard file type" do
    let(:path) { "/path/file.jpg" }
    subject { described_class.call(path) }
    it { is_expected.to eql "image/jpeg" }
  end

  context "with an unknown file type" do
    let(:path) { "/path/file.jkl" }
    subject { described_class.call(path) }
    it { is_expected.to eql "application/octet-stream" }
  end

end
