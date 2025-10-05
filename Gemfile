source "https://rubygems.org"

ruby "3.4.1"

# Rails framework principal para desenvolvimento web
# Versão 7.1.0 ou superior
# gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.0"

# Pipeline de ativos para gerenciar CSS, JS e imagens
gem "sprockets-rails"

# Adaptador PostgreSQL para Active Record
gem "pg", "~> 1.1"

# Servidor web Puma para produção
gem "puma", ">= 5.0"

# Import maps para gerenciar dependências JavaScript
gem "importmap-rails"

# Turbo para navegação SPA-like
gem "turbo-rails"

# Stimulus para interatividade JavaScript
gem "stimulus-rails"

# JBuilder para construir APIs JSON
gem "jbuilder"

# Inclui dados de fuso horário para Windows e JRuby
gem "tzinfo-data", platforms: %i[ windows jruby ]

# CSV para exportação de dados
gem "csv"

# Reduz o tempo de inicialização através de caching; necessário em config/boot.rb
gem "bootsnap", require: false

# Variantes do Active Storage para transformação de imagens
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Depuração de aplicações Rails
  gem "debug", platforms: %i[ mri windows ]

  gem 'factory_bot_rails'
end

group :development do
  # Console em páginas de exceção
  gem "web-console"

  # Badges de velocidade
  # gem "rack-mini-profiler"

  # Acelera comandos em máquinas lentas / apps grandes
  # gem "spring"

end

group :test do
  gem 'database_cleaner-active_record'
  gem 'cucumber-rails', require: false
end


gem "rspec-rails", "~> 7.1"

gem "coveralls", "~> 0.8.23"

gem "simplecov", "~> 0.16.1"

gem 'devise'
