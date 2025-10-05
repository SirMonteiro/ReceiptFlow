# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Impede a execução de testes no ambiente de produção
abort("O ambiente Rails está em modo de produção!") if Rails.env.production?

require 'rspec/rails'

# Configurações para manter o esquema do banco de dados atualizado antes dos testes
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Define o caminho para fixtures usadas nos testes
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # Se você não estiver usando ActiveRecord, ou preferir não executar cada um dos seus
  # exemplos dentro de uma transação, remova a linha a seguir ou atribua false
  # em vez de true.
  config.use_transactional_fixtures = true

  # Você pode descomentar esta linha para desativar completamente o suporte ao ActiveRecord.
  # config.use_active_record = false

  # RSpec Rails usa metadados para misturar comportamentos diferentes em seus testes,
  # por exemplo, permitindo que você chame `get` e `post` em especificações de solicitação. Exemplo:
  #
  #     RSpec.describe UsersController, type: :request do
  #       # ...
  #     end
  #
  # Os diferentes tipos disponíveis estão documentados nos recursos, como em
  # https://rspec.info/features/7-1/rspec-rails
  #
  # Você também pode inferir esses comportamentos automaticamente pela localização, por exemplo,
  # /spec/models puxaria o mesmo comportamento que `type: :model`, mas esse
  # comportamento é considerado legado e será removido em uma versão futura.
  #
  # Para habilitar esse comportamento, descomente a linha abaixo.
  # config.infer_spec_type_from_file_location!

  # Filtra linhas de gems do Rails nos rastreamentos de pilha.
  config.filter_rails_from_backtrace!
  # gems arbitrários também podem ser filtrados via:
  # config.filter_gems_from_backtrace("nome da gem")
  config.include FactoryBot::Syntax::Methods
end
