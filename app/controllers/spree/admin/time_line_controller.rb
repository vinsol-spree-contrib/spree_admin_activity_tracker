module Spree
  module Admin
    class TimeLineController < Spree::Admin::BaseController

      def index
        params[:q] ||= {}
        @search = Spree::Tracking.eager_load(:user).order(created_at: :desc).ransack(params[:q])
        @trackings = @search.result(distinct: true).page(params[:page]).per(params[:per_page] || Spree::Config[:admin_trackings_per_page])
      end

      def show
        @tracking = Spree::Tracking.eager_load(:user).find_by(id: params[:id])
      end

    end
  end
end
