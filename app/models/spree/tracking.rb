module Spree
  class Tracking < Spree::Base

    # Serialization
    serialize :entity_errors, JSON
    serialize :flash, JSON
    serialize :request_parameters, JSON
    serialize :updated_parameters, JSON

    # Associations
    belongs_to :user, required: true

    # Ransackable Attributes
    self.whitelisted_ransackable_attributes = %w(created_at entity_errors entity_type flash response_code request_parameters)
    self.whitelisted_ransackable_associations = %w(user)

    # Instance Methods
    def entity_errors
      @entity_errors ||= ActiveSupport::HashWithIndifferentAccess.new(super)
    end

    def flash
      @flash ||= ActiveSupport::HashWithIndifferentAccess.new(super)
    end

    def request_parameters
      @request_parameters ||= ActiveSupport::HashWithIndifferentAccess.new(super)
    end

    def updated_parameters
      @updated_parameters ||= ActiveSupport::HashWithIndifferentAccess.new(super)
    end

    def entity_id
      @entity_id ||= request_parameters[:id] ? request_parameters[:id] : 'None'
    end

    def controller
      @controller ||= request_parameters[:controller].gsub('spree/', '')
    end

    def action
      @action ||= request_parameters[:action]
    end

    def failed_request?
      entity_errors.present? || flash[:error].present?
    end

  end
end
