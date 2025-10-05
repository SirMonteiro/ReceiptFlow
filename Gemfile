source "https://rubygems.org"

ruby "3.4.5"

# Gemfile
gem "bcrypt", "~> 3.1.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Your app needs this to process XML files, so it stays global
gem "nokogiri", "~> 1.18"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false


group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]

  # MOVED - Test framework for BDD
  gem "rspec-rails", "~> 6.1" # Updated to a more common recent version

  # MOVED - BDD tool
  gem "cucumber-rails", require: false # ADDED require: false

  # MOVED - Integration testing library
  gem "capybara", "~> 3.40"

  # ADDED - Drives a real browser for testing
  gem "selenium-webdriver"

  # MOVED - Code coverage tools
  gem "coveralls", require: false
  gem "simplecov", require: false

  gem "database_cleaner-active_record"
end