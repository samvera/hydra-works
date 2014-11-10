require 'fast_helper'
require 'hydra/works/generic_administrative_set'

module Hydra
  module Works
    describe GenericAdministrativeSet do
      before do
        class TestAdministrativeSet
          include GenericAdministrativeSet
        end
      end

      after do
        Hydra::Works.send(:remove_const, :TestAdministrativeSet)
      end

      subject { TestWork.new }

      describe '#contains' do
        it 'should raise a NotImplementedError' do
          expect { subject.contains }.to raise_error
        end
      end
    end
  end
end
