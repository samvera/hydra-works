require 'spec_helper'

describe Hydra::Works::PersistDerivative do

  let(:generic_file)        { Hydra::Works::GenericFile::Base.new }
  let(:filename)            { "sample-file.pdf" }
  let(:destination_name)    { File.join(fixture_path, filename) }
  let(:file)                { File.new(destination_name) }
  let(:type)                { ::RDF::URI("http://pcdm.org/use#ExtractedText") }
  let(:service_type)        { ::RDF::URI("http://pcdm.org/use#ServiceFile") }


  it "persists a service file by default" do
    Hydra::Works::PersistDerivative.call(generic_file, file, destination_name)
    expect(generic_file.filter_files_by_type(service_type).first.content).to start_with("%PDF-1.3")
  end

  it "persists a dervivative as a specified type" do
    Hydra::Works::PersistDerivative.call(generic_file, file, destination_name, type: type)
    expect(generic_file.filter_files_by_type(type).first.content).to start_with("%PDF-1.3")
  end

end