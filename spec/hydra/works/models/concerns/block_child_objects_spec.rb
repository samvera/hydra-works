require 'spec_helper'

describe Hydra::Works::BlockChildObjects do
  subject { Hydra::Works::FileSet.new }

  describe '#objects=?' do
    it 'raises an error' do
      expect { subject.objects = [] }.to raise_error(StandardError, /method `objects=' not allowed for #<Hydra::Works::FileSet.*/)
    end
  end

  describe '#objects' do
    it 'raises an error' do
      expect { subject.objects }.to raise_error(StandardError, /method `objects' not allowed for #<Hydra::Works::FileSet.*/)
    end
  end
end
