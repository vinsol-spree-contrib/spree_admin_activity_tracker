require 'spec_helper'

describe Spree::Admin::OrdersController, type: :controller do

  describe 'open adjustments' do
    stub_authorization!

    let(:user) { mock_model(Spree.user_class).as_null_object }
    let(:order) { FactoryBot.create(:order)}
    let(:adjustments) { double('adjustments') }
    let(:display_value) { Spree::ShippingMethod::DISPLAY_ON_BACK_END }

    before(:each) do
      allow(controller).to receive(:spree_current_user).and_return(user)
      allow(controller).to receive(:authorize!).and_return(true)
      allow(controller).to receive(:authorize_admin).and_return(true)
    end

      it_behaves_like "trackable"

  end

end
