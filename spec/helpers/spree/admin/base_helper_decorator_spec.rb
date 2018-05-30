require 'spec_helper'

describe Spree::Admin::BaseHelper, type: :helper do

  describe 'pretty_json' do
    it "is expected to return a json with pretty format" do
      expect(pretty_json({"1": "test"})).to eq(JSON.pretty_generate({"1": "test"}))
    end
  end
end
