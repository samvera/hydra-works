require 'rails_helper'

describe Hydra::Works::GenericFile do

  describe "associations" do
    let(:work) { Hydra::Works::GenericWork.new }
    subject { Hydra::Works::GenericFile.new(work: work) }

    it "should belong to works" do
      expect(subject.work).to eq work
    end
  end
end
