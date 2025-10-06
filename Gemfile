source "https://rubygems.org"

ruby "3.4.5"

gem "rails", "~> 7.1.0"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
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
  gem "rspec-rails", "~> 7.1"
  gem "cucumber-rails", "~> 4.0", require: false
  gem "capybara", "~> 3.40"
  gem "coveralls", "~> 0.8.23"
  gem "simplecov", "~> 0.16.1"
end

gem 'devise'
