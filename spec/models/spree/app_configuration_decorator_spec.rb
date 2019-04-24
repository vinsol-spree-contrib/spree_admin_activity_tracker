require 'spec_helper'

describe Spree::AppConfiguration, type: :model do
  let (:prefs) { Rails.application.config.spree.preferences }

  describe 'admin_trackings_per_page' do
    it { expect(Spree::Config).to have_preference(:admin_trackings_per_page) }
    it { expect(Spree::Config.preferred_admin_trackings_per_page_type).to eq(:integer) }
    it { expect(Spree::Config.preferred_admin_trackings_per_page_default).to eq(45) }
  end
end
