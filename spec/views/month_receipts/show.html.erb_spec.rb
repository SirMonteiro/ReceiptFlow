# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'month_receipts/show', type: :view do
  before do
    assign(:month_receipt, MonthReceipt.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
