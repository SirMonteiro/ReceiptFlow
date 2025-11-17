# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthReceiptsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/month_receipts').to route_to('month_receipts#index')
    end

    it 'routes to #new' do
      expect(get: '/month_receipts/new').to route_to('month_receipts#new')
    end

    it 'routes to #show' do
      expect(get: '/month_receipts/1').to route_to('month_receipts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/month_receipts/1/edit').to route_to('month_receipts#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/month_receipts').to route_to('month_receipts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/month_receipts/1').to route_to('month_receipts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/month_receipts/1').to route_to('month_receipts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/month_receipts/1').to route_to('month_receipts#destroy', id: '1')
    end
  end
end
