require 'rails_helper'

describe Hydra::Works::Work do
  describe ".properties" do
    subject { described_class.properties.keys }
    it { is_expected.to eq ["has_model", "create_date", "modified_date"] }
  end
end
