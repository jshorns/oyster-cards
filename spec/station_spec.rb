require 'station'

describe Station do
  subject { described_class.new("Brixton", "Zone 2") }

  it { is_expected.to respond_to :name, :zone }

end
