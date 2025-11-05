# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'month_receipts/new', type: :view do
  before do
    assign(:month_receipt, MonthReceipt.new)
  end

  it 'renders new month_receipt form' do
    render

    assert_select 'form[action=?][method=?]', month_receipts_path, 'post' do
    end
  end
end
