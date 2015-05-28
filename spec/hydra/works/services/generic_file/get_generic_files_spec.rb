require 'spec_helper'

describe Hydra::Works::GetGenericFilesFromGenericFile do

  subject { Hydra::Works::GenericFile::Base.create }

  let(:generic_file1) { Hydra::Works::GenericFile::Base.create }
  let(:generic_file2) { Hydra::Works::GenericFile::Base.create }

  describe '#call' do
    it 'should return generic_files when generic_files are aggregated' do
      Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file1 )
      Hydra::Works::AddGenericFileToGenericFile.call( subject, generic_file2 )
      subject.save
      expect(Hydra::Works::GetGenericFilesFromGenericFile.call( subject )).to eq [generic_file1,generic_file2]
    end

  end
end
