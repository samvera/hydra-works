require 'spec_helper'

describe Hydra::Works::GetRelatedObjectsFromGenericWork do

  subject { Hydra::Works::GenericWork::Base.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.create }
  let(:generic_file1) { Hydra::Works::GenericFile::Base.create }

  describe '#call' do
    context 'with generic files and works' do
      before do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
        subject.save
      end

      it 'should return empty array when only generic files and generic works are aggregated' do
        expect(Hydra::Works::GetRelatedObjectsFromGenericWork.call( subject )).to eq []
      end

      it 'should only return related objects' do
        Hydra::Works::AddRelatedObjectToGenericWork.call( subject, object2 )
        expect(Hydra::Works::GetRelatedObjectsFromGenericWork.call( subject )).to eq [object2]
      end

      it 'should return related objects of various types' do
        Hydra::Works::AddRelatedObjectToGenericWork.call( subject, generic_work2 )
        Hydra::Works::AddRelatedObjectToGenericWork.call( subject, generic_file1 )
        Hydra::Works::AddRelatedObjectToGenericWork.call( subject, object1 )
        related_objects = Hydra::Works::GetRelatedObjectsFromGenericWork.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? generic_work2 ).to be true
        expect( related_objects.include? generic_file1 ).to be true
        expect( related_objects.size ).to eq 3
      end
   end
  end
end


