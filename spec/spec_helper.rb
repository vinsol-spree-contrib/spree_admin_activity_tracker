# Run Coverage report
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/dummy'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Views', 'app/views'
  add_group 'Libraries', 'lib'
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'factory_bot'
require 'ffaker'
require 'shoulda-matchers'
require 'devise'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/preferences'
require 'rspec-activemodel-mocks'
require 'spree/testing_support/capybara_ext'

require 'capybara/rspec'
require 'capybara-screenshot'
require 'capybara-screenshot/rspec'
require 'capybara/rails'


# Requires factories defined in lib/spree_admin_activity_tracker/factories.rb
require 'spree_admin_activity_tracker/factories'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu window-size=1920,1080])
  end
  Capybara.javascript_driver = :chrome

  Capybara::Screenshot.register_driver(:chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end


  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      # Choose a test framework:
      with.test_framework :rspec

      # Choose one or more libraries:er
      with.library :rails
    end
  end

  # Infer an example group's spec type from the file location.
  config.infer_spec_type_from_file_location!

  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::TestingSupport::UrlHelpers
  config.include Devise::TestHelpers, type: :controller

  config.mock_with :rspec
  config.color = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"


  config.use_transactional_fixtures = false
  config.fail_fast = false
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true


  # Ensure Suite is set to use transactions for speed.
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  # Before each spec check if it is a Javascript test and switch between using database transactions or not where necessary.
  config.before :each do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  # After each spec clean the database.
  config.after :each do
    DatabaseCleaner.clean
  end

  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = "random"
end

def setup_for_admin_interface
  allow(controller).to receive(:generate_admin_api_key)
  allow(controller).to receive(:authorize_admin)
  allow(Spree::Admin::BaseController).to receive(:ssl_required)
  allow(Spree::Config).to receive(:[])
end
ActiveJob::Base.queue_adapter = :test
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

