source "https://rubygems.org"

ruby "3.4.1"

# Gemfile
gem "bcrypt", "~> 3.1.7"

gem "rails", "~> 7.1.0"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

# Your app needs this to process XML files, so it stays global
gem "nokogiri", "~> 1.18"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "csv"
gem "bootsnap", require: false

# Necessário para criar gráficos
gem 'chartkick'
gem 'groupdate' # útil para agrupar por data (usar o mês...)

# Busca em texto PostgreSQL
gem 'pg_search'

# Variantes do Active Storage para transformação de imagens
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem "web-console"
  # gem "rack-mini-profiler"
  # gem "spring"
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'
  gem "rspec-rails", "~> 7.1"
  gem "cucumber-rails", "~> 4.0", require: false
  gem "capybara", "~> 3.40"
end

  gem "selenium-webdriver"

  gem "coveralls", require: false
  gem "simplecov", require: false
  gem 'devise'

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false
