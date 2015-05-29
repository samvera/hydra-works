require 'spec_helper'

describe Hydra::Works::GetRelatedObjectsFromGenericFile do

  subject { Hydra::Works::GenericFile::Base.create }

  let(:object1) { Hydra::PCDM::Object.create }
  let(:object2) { Hydra::PCDM::Object.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_file1) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.create }

  describe '#call' do
    context 'with generic files' do
      before do
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
        subject.save
      end

      it 'should return empty array when only generic files are aggregated' do
        expect(Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )).to eq []
      end

      it 'should only return related objects' do
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object2 )
        expect(Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )).to eq [object2]
      end

      it 'should return related objects of various types' do
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, generic_work1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddRelatedObjectToGenericFile.call( subject, object1 )
        related_objects = Hydra::Works::GetRelatedObjectsFromGenericFile.call( subject )
        expect( related_objects.include? object1 ).to be true
        expect( related_objects.include? generic_work1 ).to be true
        expect( related_objects.include? generic_file1 ).to be true
        expect( related_objects.size ).to eq 3
      end
   end
  end
end


