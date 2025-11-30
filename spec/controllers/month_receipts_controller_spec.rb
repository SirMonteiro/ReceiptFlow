# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthReceiptsController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'instance variables' do
      it 'assigns @selected_month' do
        get :index
        expect(assigns(:selected_month)).to be_a(Date)
      end

      it 'assigns @danfes as an ActiveRecord relation' do
        get :index
        expect(assigns(:danfes)).to respond_to(:each)
      end

      it 'assigns @available_months as an array' do
        get :index
        expect(assigns(:available_months)).to be_an(Array)
      end

      it 'assigns @mes_pt with Portuguese month name' do
        get :index, params: { month: 10, year: 2025 }
        expect(assigns(:mes_pt)).to eq('Outubro')
      end

      it 'assigns @ano with year string' do
        get :index, params: { month: 10, year: 2025 }
        expect(assigns(:ano)).to eq('2025')
      end

      it 'assigns @selected_month_num with month number' do
        get :index, params: { month: 10, year: 2025 }
        expect(assigns(:selected_month_num)).to eq(10)
      end
    end

    context 'MESES_PT constant' do
      it 'has all 12 months defined' do
        expect(MonthReceiptsController::MESES_PT.keys.count).to eq(12)
      end

      it 'maps English month names to Portuguese' do
        expect(MonthReceiptsController::MESES_PT['January']).to eq('Janeiro')
        expect(MonthReceiptsController::MESES_PT['February']).to eq('Fevereiro')
        expect(MonthReceiptsController::MESES_PT['March']).to eq('Março')
        expect(MonthReceiptsController::MESES_PT['December']).to eq('Dezembro')
      end
    end

    context 'date calculations' do
      it 'calculates beginning_of_month correctly' do
        get :index, params: { month: 10, year: 2025 }
        selected = assigns(:selected_month)
        expect(selected.beginning_of_month).to eq(Date.new(2025, 10, 1))
      end

      it 'calculates end_of_month correctly' do
        get :index, params: { month: 10, year: 2025 }
        selected = assigns(:selected_month)
        expect(selected.end_of_month).to eq(Date.new(2025, 10, 31))
      end

      it 'handles February correctly in leap year' do
        get :index, params: { month: 2, year: 2024 }
        selected = assigns(:selected_month)
        expect(selected.end_of_month.day).to eq(29)
      end

      it 'handles February correctly in non-leap year' do
        get :index, params: { month: 2, year: 2023 }
        selected = assigns(:selected_month)
        expect(selected.end_of_month.day).to eq(28)
      end
    end

    context 'query optimization' do
      it 'keeps the number of SQL queries low' do
        create_list(:danfe, 5, user: user, data_saida: Date.new(2025, 10, 15))

        query_count = count_sql_queries do
          get :index, params: { month: 10, year: 2025 }
        end

        expect(query_count).to be_between(1, 5)
      end
    end
  end

  describe 'GET #show' do
    let(:danfe) { create(:danfe, user: user) }

    it 'assigns the requested danfe' do
      get :show, params: { id: danfe.id }
      expect(assigns(:danfe)).to eq(danfe)
      expect(response).to be_successful
    end

    it 'redirects to index when the danfe is not found' do
      get :show, params: { id: '999999' }
      expect(response).to redirect_to(month_receipts_path)
      expect(flash[:alert]).to eq('Não encontramos este comprovante.')
    end
  end
end

def count_sql_queries(&block)
  queries = 0
  callback = lambda do |_name, _start, _finish, _message_id, payload|
    next if payload[:cached] || payload[:name]&.match?(/SCHEMA|TRANSACTION/)

    queries += 1
  end

  ActiveSupport::Notifications.subscribed(callback, 'sql.active_record', &block)

  queries
end
