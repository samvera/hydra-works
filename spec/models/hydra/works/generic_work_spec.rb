require 'rails_helper'

describe Hydra::Works::GenericWork do
  describe "basic metadata" do
    it "should have dc properties" do
      subject.title = ['foo', 'bar']
      expect(subject.title).to eq ['foo', 'bar']
    end
  end
end

