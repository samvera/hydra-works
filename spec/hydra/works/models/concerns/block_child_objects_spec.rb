require 'spec_helper'

describe Hydra::Works::BlockChildObjects do
  subject { Hydra::Works::GenericFile::Base.new }

  describe '#objects=?' do
    it 'raises an error' do
      expect { subject.objects = [] }.to raise_error(StandardError, /method `objects=' not allowed for #<Hydra::Works::GenericFile::Base.*/)
    end
  end

  describe '#objects' do
    it 'raises an error' do
      expect { subject.objects }.to raise_error(StandardError, /method `objects' not allowed for #<Hydra::Works::GenericFile::Base.*/)
    end
  end
end
