# frozen_string_literal: true

json.array! @month_receipts, partial: 'month_receipts/month_receipt', as: :month_receipt
