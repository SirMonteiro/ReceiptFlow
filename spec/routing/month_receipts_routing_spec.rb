# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthReceiptsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/month_receipts').to route_to('month_receipts#index')
    end

    it 'routes to #show' do
      expect(get: '/month_receipts/1').to route_to('month_receipts#show', id: '1')
    end
  end
end
