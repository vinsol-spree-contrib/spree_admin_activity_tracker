require 'spec_helper'

describe Spree::Api::BaseController, type: :controller do

  describe "included module" do
    it "is expected to have included trackable module" do
      expect(Spree::Api::BaseController.ancestors.include?(Spree::Trackable)).to eq(true)
    end
  end
end
