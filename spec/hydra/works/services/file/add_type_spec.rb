require 'spec_helper'

describe Hydra::Works::AddTypeToFile do

  let(:file) { Hydra::PCDM::File.new }

  context "with a file that has no type" do
    let(:uri)  { ::RDF::URI("http://example.com/MyType") }
    subject { described_class.call(file, uri).metadata_node.type }
    it { is_expected.to include(uri)}
  end

  context "when adding a type that already exists" do
    let(:uri)  { RDFVocabularies::PCDMTerms.File }
    subject { described_class.call(file, uri).metadata_node.type }
    it { is_expected.to eql [uri] }
  end

end
