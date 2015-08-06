require 'spec_helper'

describe Hydra::Works::GenericFile::MimeTypes do

  subject { Hydra::Works::GenericFile::Base.new }

  describe "#pdf?" do
    before do
      allow(subject).to receive(:mime_type).and_return('application/pdf')
    end
    it "should be true" do
      expect(subject.pdf?).to be true
    end
  end

  describe "#image?" do
    before do
      allow(subject).to receive(:mime_type).and_return('image/jpeg')
    end
    it "should be true" do
      expect(subject.image?).to be true
    end
  end

  describe "#video?" do
    before do
      allow(subject).to receive(:mime_type).and_return('video/mp4')
    end
    it "should be true" do
      expect(subject.video?).to be true
    end
  end

  describe "#audio?" do
    before do
      allow(subject).to receive(:mime_type).and_return('audio/mp3')
    end
    it "should be true" do
      expect(subject.audio?).to be true
    end
  end

  describe "#office_document?" do
    before do
      allow(subject).to receive(:mime_type).and_return('application/msword')
    end
    it "should be true" do
      expect(subject.office_document?).to be true
    end
  end

  describe "#collection?" do
    it "should be false" do
      expect(subject.collection?).to be false
    end
  end

  describe "#file_format?" do
    it "should handle both mime and format_label" do
      allow(subject).to receive(:mime_type).and_return('image/png')
      allow(subject).to receive(:format_label).and_return(['Portable Network Graphics'])
      expect(subject.file_format).to eq 'png (Portable Network Graphics)'
    end
    it "should handle just mime type" do
      allow(subject).to receive(:mime_type).and_return('image/png')
      allow(subject).to receive(:format_label).and_return([])
      expect(subject.file_format).to eq 'png'
    end
    it "should handle just format_label" do
      allow(subject).to receive(:mime_type).and_return('')
      allow(subject).to receive(:format_label).and_return(['Portable Network Graphics'])
      expect(subject.file_format).to eq ['Portable Network Graphics']
    end
  end

end
