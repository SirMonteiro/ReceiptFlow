# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DanfesController', type: :request do
  let!(:user) { User.create!(nome: 'Gerente', email: 'gerente@exemplo.com', password: 'senha123') }

  before { sign_in user }

  describe 'GET /filter' do
    context 'quando o intervalo de datas é válido' do
      it 'redireciona para a rota de resultados com as datas' do
        params = { data_inicial: '2024-01-01', data_final: '2024-12-31' }
        get filter_danfes_path, params: params

        expect(response).to redirect_to(result_danfes_path(params))
      end
    end

    context 'quando o intervalo de datas é inválido' do
      it 'retorna erro ou redireciona com aviso' do
        get filter_danfes_path, params: { data_inicial: '2024-12-31', data_final: '2024-01-01' }
        expect(response).to redirect_to(filter_danfes_path)
        expect(flash[:alert]).to eq('Intervalo de datas inválido. Verifique as datas e tente novamente.')
      end
    end
  end

  describe 'GET /results' do
    context 'com duas notas no período' do
      it 'exibe as notas retornadas pelo stub do scope(stub)' do
        danfe1 = Danfe.create!(
          number: 1,
          user: user,
          cliente: 'Cliente 1',
          valor: 100.0,
          chave_acesso: '123456789012345678901234567890000001',
          natureza_operacao: 'Venda',
          remetente: 'Remetente A',
          destinatario: 'Destinatário A',
          descricao_produtos: 'Produto A',
          valores_totais: 100.0,
          impostos: 10.0,
          cfop: '5102',
          cst: '060',
          ncm: '12345678',
          transportadora: 'Transportadora X',
          data_saida: '2024-05-10'
        )

        danfe2 = Danfe.create!(
          number: 2,
          user: user,
          cliente: 'Cliente 2',
          valor: 200.0,
          chave_acesso: '123456789012345678901234567890000002',
          natureza_operacao: 'Venda',
          remetente: 'Remetente B',
          destinatario: 'Destinatário B',
          descricao_produtos: 'Produto B',
          valores_totais: 200.0,
          impostos: 20.0,
          cfop: '5102',
          cst: '060',
          ncm: '87654321',
          transportadora: 'Transportadora Y',
          data_saida: '2024-06-15'
        )

        allow(Danfe).to receive(:do_periodo).and_return([danfe1, danfe2])

        get result_danfes_path, params: { data_inicial: '2024-01-01', data_final: '2024-12-31' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Cliente 1')
        expect(response.body).to include('Cliente 2')
      end
    end

    context 'com dez notas no período(stub)' do
      it 'exibe todas as notas retornadas pelo stub do scope' do
        danfes = (1..10).map do |i|
          Danfe.create!(
            number: i,
            user: user,
            cliente: "Cliente #{i}",
            valor: i * 100.0,
            chave_acesso: "1234567890123456789012345678900000#{i}",
            natureza_operacao: 'Venda',
            remetente: "Remetente #{i}",
            destinatario: "Destinatário #{i}",
            descricao_produtos: "Produto #{i}",
            valores_totais: i * 100.0,
            impostos: i * 10.0,
            cfop: '5102',
            cst: '060',
            ncm: "1000000#{i}",
            transportadora: "Transportadora #{i}",
            data_saida: "2024-0#{(i % 9) + 1}-10"
          )
        end

        allow(Danfe).to receive(:do_periodo).and_return(danfes)

        get result_danfes_path, params: { data_inicial: '2024-01-01', data_final: '2024-12-31' }

        expect(response).to have_http_status(:ok)
        danfes.each do |danfe|
          expect(response.body).to include(danfe.cliente)
        end
      end
    end

    context 'quando não há resultados(stub)' do
      it 'exibe mensagem de ausência de resultados' do
        allow(Danfe).to receive(:do_periodo).and_return(Danfe.none)
        get result_danfes_path, params: { data_inicial: '2025-01-01', data_final: '2025-01-10' }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Nenhum resultado encontrado')
      end
    end

    context 'com duas notas no período' do
      it 'exibe as notas do período' do
        Danfe.create!(
          number: 3,
          user: user,
          cliente: 'Cliente 1',
          valor: 100.0,
          chave_acesso: '123456789012345678901234567890000001',
          natureza_operacao: 'Venda',
          remetente: 'Remetente A',
          destinatario: 'Destinatário A',
          descricao_produtos: 'Produto A',
          valores_totais: 100.0,
          impostos: 10.0,
          cfop: '5102',
          cst: '060',
          ncm: '12345678',
          transportadora: 'Transportadora X',
          data_saida: '2024-05-10'
        )

        Danfe.create!(
          number: 4,
          user: user,
          cliente: 'Cliente 2',
          valor: 200.0,
          chave_acesso: '123456789012345678901234567890000002',
          natureza_operacao: 'Venda',
          remetente: 'Remetente B',
          destinatario: 'Destinatário B',
          descricao_produtos: 'Produto B',
          valores_totais: 200.0,
          impostos: 20.0,
          cfop: '5102',
          cst: '060',
          ncm: '87654321',
          transportadora: 'Transportadora Y',
          data_saida: '2024-06-15'
        )

        get result_danfes_path, params: { data_inicial: '2024-01-01', data_final: '2024-12-31' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Cliente 1')
        expect(response.body).to include('Cliente 2')
      end
    end

    context 'com dez notas no período' do
      it 'exibe todas as notas do período' do
        (1..10).each do |i|
          Danfe.create!(
            number: i + 10,
            user: user,
            cliente: "Cliente #{i}",
            valor: i * 100.0,
            chave_acesso: "1234567890123456789012345678900000#{i}",
            natureza_operacao: 'Venda',
            remetente: "Remetente #{i}",
            destinatario: "Destinatário #{i}",
            descricao_produtos: "Produto #{i}",
            valores_totais: i * 100.0,
            impostos: i * 10.0,
            cfop: '5102',
            cst: '060',
            ncm: "1000000#{i}",
            transportadora: "Transportadora #{i}",
            data_saida: "2024-0#{(i % 9) + 1}-10"
          )
        end

        get result_danfes_path, params: { data_inicial: '2024-01-01', data_final: '2024-12-31' }

        expect(response).to have_http_status(:ok)
        (1..10).each do |i|
          expect(response.body).to include("Cliente #{i}")
        end
      end
    end

    context 'quando não há resultados' do
      it 'exibe mensagem de ausência de resultados' do
        get result_danfes_path, params: { data_inicial: '2025-01-01', data_final: '2025-01-10' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Nenhum resultado encontrado')
      end
    end
  end
end
