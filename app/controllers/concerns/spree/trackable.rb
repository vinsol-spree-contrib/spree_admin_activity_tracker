module Spree
  module Trackable

    extend ActiveSupport::Concern

    included do
      with_options if: :track_changes? do
        prepend_before_action :store_request_params
        prepend_after_action :track_changes
      end
    end

    private

    def track_changes?
      ( !request.get? || adjustment_request ) && try_spree_current_user.admin? && try_spree_current_user.present?
    end

    def adjustment_request
      request['action'].in? ['close_adjustments', 'open_adjustments']
    end

    def store_request_params
      @request_params = params.dup
    end

    def track_changes
      tracking = Spree::Tracking.new(
        request_parameters: @request_params,
        updated_parameters: params,
        ip_address: request.remote_ip,
        entity_type: fetch_entity_type,
        response_code: response.status,
        user: try_spree_current_user,
        flash: flash.to_hash,
        entity_errors: object_errors
      )

      tracking.save
    end

    def fetch_entity_type
      if respond_to?(:model_class, true) && model_class.present?
        model_class.to_s.demodulize
      else
        controller_name
      end
    end

    def object_errors
      begin
        if trackable_object.errors.messages.values.compact.reject(&:blank?).present?
          trackable_object.errors.messages
        else
          {}
        end
      rescue
        {}
      end
    end

    def trackable_object
      @object || instance_variable_get('@' + controller_name.singularize)
    end

  end
end
