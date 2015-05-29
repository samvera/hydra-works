require 'spec_helper'

describe Hydra::Works::MoveGenericFileToGenericWork do
  let(:source_work) { Hydra::Works::GenericWork.create }
  let(:target_work) { Hydra::Works::GenericWork.create }
  let(:file1) { Hydra::Works::GenericFile.create }
  let(:file2) { Hydra::Works::GenericFile.create }
  context "move generic file" do 
    before do 
      Hydra::Works::AddGenericFileToGenericWork.call(source_work, file1)
      Hydra::Works::AddGenericFileToGenericWork.call(source_work, file2)
    end
    it "moves file from one work to another" do
      expect(source_work.generic_files).to eq([file1, file2])
      expect(target_work.generic_files).to eq([])
      Hydra::Works::MoveGenericFileToGenericWork.call(source_work, target_work, file1)
      expect(source_work.generic_files).to eq([file2])
      expect(target_work.generic_files).to eq([file1])
    end
  end
end