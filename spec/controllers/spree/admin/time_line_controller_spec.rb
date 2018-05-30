require 'spec_helper'

describe Spree::Admin::TimeLineController, type: :controller do

  before { setup_for_admin_interface }

  describe 'GET index' do
    before { get :index }

    it "is expected to render index page" do
      expect(response).to render_template(:index)
    end

    it "is expected to assign a search instance variable" do
      expect(assigns(:search)).to be_instance_of(Ransack::Search)
    end

    it "is expected to assign a tracking instance variable" do
      expect(assigns(:trackings).is_a? ActiveRecord::Relation).to eq(true)
    end
  end

  describe 'GET show' do
    let(:tracking) { FactoryBot.create(:tracking) }

    before { get :show, params: { id: tracking.id } }

    it "is expected to render show page" do
      expect(response).to render_template(:show)
    end

    it "is expected to assign a tracking instance variable" do
      expect(assigns(:tracking)).to be_instance_of(Spree::Tracking)
    end
  end
end
