require 'spec_helper'

describe Hydra::Works::RemoveGenericWorkFromGenericWork do

  subject { Hydra::Works::GenericWork::Base.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work3) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work4) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work5) { Hydra::Works::GenericWork::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }


  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work3 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work4 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work5 )
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work1,generic_work2,generic_work3,generic_work4,generic_work5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_work1 ) ).to eq generic_work1
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work2,generic_work3,generic_work4,generic_work5]
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file1]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_work5 ) ).to eq generic_work5
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work1,generic_work2,generic_work3,generic_work4]
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file1]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveGenericWorkFromGenericWork.call( subject, generic_work3 ) ).to eq generic_work3
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work1,generic_work2,generic_work4,generic_work5]
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file1]
      end
    end
  end
end
