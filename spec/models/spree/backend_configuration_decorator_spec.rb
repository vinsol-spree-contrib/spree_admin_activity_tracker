require 'spec_helper'

describe Spree::BackendConfiguration, type: :model do

  describe 'time line constant' do
    it { expect(Spree::BackendConfiguration::TIME_LINE).to eq([:time_line]) }
  end
end
