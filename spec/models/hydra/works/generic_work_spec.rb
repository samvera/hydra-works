require 'rails_helper'

describe Hydra::Works::GenericWork do
  describe "basic metadata" do
    it "should have dc properties" do
      subject.title = ['foo', 'bar']
      expect(subject.title).to eq ['foo', 'bar']
    end
  end

  describe "associations" do
    let(:file) { Hydra::Works::File.new }
    context "base model" do
      subject { Hydra::Works::GenericWork.create(title: ['test'], files: [file]) }

      it "should have many generic files" do
        expect(subject.files).to eq [file]
      end
    end

    context "sub-class" do
      before do
        class TestWork < Hydra::Works::GenericWork
        end
      end

      subject { TestWork.create(title: ['test'], files: [file]) }

      it "should have many generic files" do
        expect(subject.files).to eq [file]
      end
    end
  end

  describe "#destroy", skip: "Is this behavior we need? Could other works be pointing at the file?" do
    let(:file1) { Hydra::Works::File.new }
    let(:file2) { Hydra::Works::File.new }
    let!(:work) { Hydra::Works::GenericWork.create(files: [file1, file2]) }

    it "should destroy the files" do
      expect { work.destroy }.to change{ Hydra::Works::File.count }.by(-2)
    end
  end
end

