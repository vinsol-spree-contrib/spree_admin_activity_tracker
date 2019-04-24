require 'spec_helper'

shared_examples_for 'trackable' do
  let (:tracking) {create (:tracking)}

  describe "extended module" do
    it "is expected to have extended active support concern module" do
      expect(Spree::Trackable.singleton_class.ancestors.include?(ActiveSupport::Concern)).to eq(true)
    end
  end

  describe 'track_changes?' do
    context "admin is logged in" do
      context "request is get and not of adjustment" do
        it "returns false" do
          expect(request.get?).to eq(true)
          expect(controller.send(:track_changes?)).to eq(false)
        end
      end

      context "request is of adjustment" do
        before { get :close_adjustments, params: { id: order.number } }

        it "returns true" do
          expect(controller.send(:track_changes?)).to eq(true)
        end
      end

      context "request is get and not of adjustment" do
        before { get :index }

        it "returns false" do
          expect(controller.send(:track_changes?)).to eq(false)
        end
      end
    end
  end

  describe 'adjustment_request' do
    context 'when request action is close_adjustments' do
      before { get :close_adjustments, params: { id: order.number } }

      it "returns true" do
        expect(controller.send(:adjustment_request)).to eq(true)
      end
    end

    context 'when request action is open_adjustments' do
      before { get :open_adjustments, params: { id: order.number } }

      it "returns true" do
        expect(controller.send(:adjustment_request)).to eq(true)
      end
    end

    context 'when request action is neither open nor close adjustment' do
      before { get :index }

      it "returns false" do
        expect(controller.send(:adjustment_request)).to eq(false)
      end
    end
  end

  describe 'store_request_params' do
    before { get :open_adjustments, params: { id: order.number } }

    it "assigns a request params variables " do
      expect(assigns(:request_params)).to be_instance_of(ActionController::Parameters)
    end
  end

  describe 'track_changes' do
    before { get :open_adjustments, params: { id: order.number } }

    it "saves the tracking and returns true" do
      expect(controller.send(:track_changes)).to eq(true)
    end

    let(:tracking) { Spree::Tracking.first }

    it "sets the flash value" do
      expect(tracking.flash).to eq({"success"=>"All adjustments successfully opened!"})
    end

    it " sets the request parameters" do
      expect(tracking.request_parameters).to eq({"id"=>order.number, "controller"=>"spree/admin/orders", "action"=>"open_adjustments"})
    end

    it "sets the updated paramters" do
      expect(tracking.updated_parameters).to eq({"id"=>order.number, "controller"=>"spree/admin/orders", "action"=>"open_adjustments"})
    end

    it "sets the ip address" do
      expect(tracking.ip_address).to eq("0.0.0.0")
    end

    it "sets the entity type" do
      expect(tracking.entity_type).to eq("Spree::Order")
    end

    it "sets the response code" do
      expect(tracking.response_code).to eq(302)
    end

    it "sets the user" do
      expect(tracking.user_id).to eq(user.id)
    end

    it "sets the entity errors" do
      expect(tracking.entity_errors).to eq({})
    end
  end
end
