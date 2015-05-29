require 'spec_helper'

describe Hydra::Works::GetGenericFilesFromGenericWork do

  subject { Hydra::Works::GenericWork::Base.create }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.create }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.create }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.create }

  describe '#call' do
    it 'should return empty array when only generic_works are aggregated' do
      Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
      Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
      subject.save
      expect(Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq []
    end

    context 'with generic_files and generic_works' do
      before do
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        subject.save
      end

      it 'should only return generic_files' do
        expect(Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file1,generic_file2]
      end
   end
  end
end
