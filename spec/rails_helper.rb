# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'


Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
# --- ADD THIS LINE ---
require 'capybara/rspec' # This will fix your feature specs

# Add additional requires below this line. Rails is not loaded until this point!

# ...
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# --- UNCOMMENT THIS LINE ---
# This is the most important fix! It will load all your old helper files.
Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }
# -------------------------

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

 
  config.use_transactional_fixtures = true

  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  config.filter_rails_from_backtrace!

  config.include AuthHelpers, type: :request

  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!

end