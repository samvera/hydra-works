require 'fast_helper'
require 'hydra/works/properties'

module Hydra
  module Works
    describe Properties do
      it 'defines AGGREGATES' do
        expect(Properties::AGGREGATES).to eq('ore:aggregates')
      end

      it 'defines HAS_FILE' do
        expect(Properties::HAS_FILE).to eq('hydra:hasFile')
      end

      it 'defines HAS_MEMBER' do
        expect(Properties::HAS_MEMBER).to eq('hydra:hasMember')
      end
    end
  end
end
