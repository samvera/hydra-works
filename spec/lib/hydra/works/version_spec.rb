require 'fast_helper'
require 'hydra/works/version'

describe Hydra::Works::VERSION do
  it 'returns current version' do
    expect(Hydra::Works::VERSION).to eq('0.0.1.pre')
  end
end
