require 'fast_helper'

describe Hydra::Works::VERSION do
  it 'returns current version' do
    expect(Hydra::Works::VERSION).to eq('0.0.1.pre')
  end
end
