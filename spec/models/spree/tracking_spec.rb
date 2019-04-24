require 'spec_helper'

describe Spree::Tracking, type: :model do

  describe 'association' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'serializations' do
    context "entity errors" do
      it "is expected to respond to entity errors" do
        expect(Spree::Tracking.new).to respond_to(:entity_errors)
      end

      it "is expected to give json" do
        expect(Spree::Tracking.new.entity_errors).to eq({})
      end
    end

    context "flash" do
      it "is expected to respond to flash" do
        expect(Spree::Tracking.new).to respond_to(:flash)
      end

      it "is expected to give json" do
        expect(Spree::Tracking.new.flash).to eq({})
      end
    end

    context "request_parameters" do
      it "is expected to respond to request parameters" do
        expect(Spree::Tracking.new).to respond_to(:request_parameters)
      end

      it "is expected to give json" do
        expect(Spree::Tracking.new.request_parameters).to eq({})
      end
    end

    context "updated_parameters" do
      it "is expected to respond to updated parameters" do
        expect(Spree::Tracking.new).to respond_to(:updated_parameters)
      end

      it "is expected to give json" do
        expect(Spree::Tracking.new.updated_parameters).to eq({})
      end
    end
  end

  describe 'Instance methods' do
    describe 'failed request' do
      context "when entity_errors and flash[:error] are not present" do
        it "is expected to return true" do
          expect(Spree::Tracking.new.failed_request?).to eq(false)
        end
      end

      context "when entity errors is present" do
        let(:tracking) { FactoryBot.create(:tracking) }
        before { tracking.entity_errors[:error] = 'error' }

        it "is expected to return false" do
          expect(tracking.failed_request?).to eq(true)
        end
      end

      context "when flash errors is present" do
        let(:tracking) { FactoryBot.create(:tracking) }
        before { tracking.flash[:error] = 'error' }

        it "is expected to return false" do
          expect(tracking.failed_request?).to eq(true)
        end
      end
    end

    describe 'request action' do
      let(:tracking) { FactoryBot.create(:tracking) }
      before { tracking.request_parameters[:action] = 'test' }

      it "is expected to return request_parameters action" do
        expect(tracking.action).to eq('test')
      end
    end

    describe 'controller' do
      let(:tracking) { FactoryBot.create(:tracking) }
      before { tracking.request_parameters[:controller] = 'test' }

      it "is expected to return request_parameters controller" do
        expect(tracking.controller).to eq('test')
      end
    end

    describe 'entity_id' do
      let(:tracking) { FactoryBot.create(:tracking) }
      before { tracking.request_parameters[:id] = 'test' }

      it "is expected to return request_parameters entity_id" do
        expect(tracking.entity_id).to eq('test')
      end
    end
  end
end
