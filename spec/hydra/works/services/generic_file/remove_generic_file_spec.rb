require 'spec_helper'

describe Hydra::Works::RemoveGenericFileFromGenericFile do

  subject { Hydra::Works::GenericFile::Base.new }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file3) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file4) { Hydra::Works::GenericFile::Base.new }
  let(:generic_file5) { Hydra::Works::GenericFile::Base.new }

  describe '#call' do
    context 'when multiple collections' do
      before do
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file3 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file4 )
        Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file5 )
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove first collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_file1 ) ).to eq generic_file1
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file2,generic_file3,generic_file4,generic_file5]
      end

      it 'should remove last collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_file5 ) ).to eq generic_file5
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2,generic_file3,generic_file4]
      end

      it 'should remove middle collection' do
        expect( Hydra::Works::RemoveGenericFileFromGenericFile.call( subject, generic_file3 ) ).to eq generic_file3
        expect( Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2,generic_file4,generic_file5]
      end
    end
  end
end
