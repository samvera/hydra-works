require 'rails_helper'

describe Hydra::Works::GenericFile do

  describe "associations" do
    let(:work) { Hydra::Works::GenericWork.new }
    context "base model" do
      subject { Hydra::Works::GenericFile.new(work: work) }

      it "should belong to works" do
        expect(subject.work).to eq work
      end
    end

    context "sub-class" do
      before do
        class TestFile < Hydra::Works::GenericFile
        end
      end
      subject { TestFile.new(work: work) }

      it "should belong to works" do
        expect(subject.work).to eq work
      end
    end
  end
end
