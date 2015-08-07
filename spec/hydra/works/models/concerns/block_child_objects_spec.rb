require 'spec_helper'

describe Hydra::Works::BlockChildObjects do

  subject { Hydra::Works::GenericFile::Base.new }

  describe "#child_objects=?" do
    it "should raise an error" do
      expect { subject.child_objects = [] }.to raise_error(StandardError, /method `child_objects=' not allowed for #<Hydra::Works::GenericFile::Base.*/)
    end
  end

  describe "#child_objects" do
    it "should raise an error" do
      expect { subject.child_objects }.to raise_error(StandardError, /method `child_objects' not allowed for #<Hydra::Works::GenericFile::Base.*/)
    end
  end

end
