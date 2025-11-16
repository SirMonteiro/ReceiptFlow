# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'month_receipts/edit', type: :view do
  let(:month_receipt) do
    MonthReceipt.create!
  end

  before do
    assign(:month_receipt, month_receipt)
  end

  it 'renders the edit month_receipt form' do
    render

    assert_select 'form[action=?][method=?]', month_receipt_path(month_receipt), 'post' do
    end
  end
end
