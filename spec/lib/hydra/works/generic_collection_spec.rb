require 'fast_helper'
require 'hydra/works/generic_collection'

module Hydra
  module Works
    describe GenericCollection do
      before do
        class TestCollection
          include GenericCollection
        end
      end

      after do
        Hydra::Works.send(:remove_const, :TestCollection)
      end

      subject { TestWork.new }

      describe '#aggregates' do
        it 'should raise a NotImplementedError' do
          expect { subject.aggregates }.to raise_error
        end
      end
    end
  end
end
