require 'spec_helper'

describe Hydra::Works::RemoveGenericFileFromGenericWork do

  subject { Hydra::Works::GenericWork::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file3) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file4) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file5) { Hydra::Works::GenericFile::Base.new }

  let(:generic_work1) { Hydra::Works::GenericWork::Base.new }
  let(:generic_work2) { Hydra::Works::GenericWork::Base.new }

  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file2 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work2 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file3 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file4 )
        Hydra::Works::AddGenericWorkToGenericWork.call( subject, generic_work1 )
        Hydra::Works::AddGenericFileToGenericWork.call( subject, generic_file5 )
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file1,generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_file1 ) ).to eq generic_file1
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file2,generic_file3,generic_file4,generic_file5]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work2,generic_work1]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_file5 ) ).to eq generic_file5
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file1,generic_file2,generic_file3,generic_file4]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work2,generic_work1]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericWork.call( subject, generic_file3 ) ).to eq generic_file3
        expect( Hydra::Works::GetGenericFilesFromGenericWork.call( subject )).to eq [generic_file1,generic_file2,generic_file4,generic_file5]
        expect( Hydra::Works::GetGenericWorksFromGenericWork.call( subject )).to eq [generic_work2,generic_work1]
      end
    end
  end
end