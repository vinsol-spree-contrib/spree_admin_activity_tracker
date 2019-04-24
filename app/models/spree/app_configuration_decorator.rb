Spree::AppConfiguration.class_eval do
  preference :admin_trackings_per_page, :integer, default: 45
end
