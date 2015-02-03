require 'rails_helper'

describe Hydra::Works::GenericWork do
  describe "basic metadata" do
    it "should have dc properties" do
      subject.title = ['foo', 'bar']
      expect(subject.title).to eq ['foo', 'bar']
    end
  end

  describe "associations" do
    let(:file) { Hydra::Works::GenericFile.new }
    subject { Hydra::Works::GenericWork.create(title: ['test'], generic_files: [file]) }

    it "should have many generic files" do
      expect(subject.generic_files).to eq [file]
    end
  end
end

