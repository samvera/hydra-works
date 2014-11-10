require 'fast_helper'
require 'hydra/works/generic_work'

module Hydra
  module Works
    describe GenericWork do
      before do
        class TestWork
          include GenericWork
        end
      end

      after do
        Hydra::Works.send(:remove_const, :TestWork)
      end

      subject { TestWork.new }

      describe '#member_works' do
        it 'should raise a NotImplementedError' do
          expect { subject.member_works }.to raise_error
        end
      end

      describe '#files' do
        it 'should raise a NotImplementedError' do
          expect { subject.files }.to raise_error
        end
      end
    end
  end
end
