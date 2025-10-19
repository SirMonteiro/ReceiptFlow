require 'rails_helper'

RSpec.describe "/month_receipts", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }

  before do
    # Mock authentication - adjust according to your auth system
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /index" do
    context "with no parameters (default behavior)" do
      it "renders a successful response" do
        get month_receipts_url
        expect(response).to be_successful
      end

      it "defaults to current month and year" do
        travel_to Date.new(2025, 10, 19) do
          get month_receipts_url
          expect(assigns(:selected_month)).to eq(Date.new(2025, 10, 1))
          expect(assigns(:mes_pt)).to eq("Outubro")
          expect(assigns(:ano)).to eq("2025")
        end
      end
    end
    context "with specific month and year parameters" do
      let!(:january_danfe) { create(:danfe, :january_2025, user: user, valor: 1500.00) }
      let!(:february_danfe) { create(:danfe, :february_2025, user: user, valor: 2000.00) }

      it "filters danfes by the specified month" do
        get month_receipts_url, params: { month: 1, year: 2025 }

        expect(assigns(:danfes)).to include(january_danfe)
        expect(assigns(:danfes)).not_to include(february_danfe)
      end

      it "displays the correct Portuguese month name" do
        get month_receipts_url, params: { month: 1, year: 2025 }

        expect(assigns(:mes_pt)).to eq("Janeiro")
        expect(assigns(:ano)).to eq("2025")
        expect(assigns(:selected_month_num)).to eq(1)
      end

      it "filters danfes for February" do
        get month_receipts_url, params: { month: 2, year: 2025 }

        expect(assigns(:danfes)).to include(february_danfe)
        expect(assigns(:danfes)).not_to include(january_danfe)
        expect(assigns(:mes_pt)).to eq("Fevereiro")
      end
    end

    context "when no danfes exist for the selected month" do
      it "returns an empty collection" do
        get month_receipts_url, params: { month: 3, year: 2025 }

        expect(assigns(:danfes)).to be_empty
      end

      it "still sets the month variables correctly" do
        get month_receipts_url, params: { month: 3, year: 2025 }

        expect(assigns(:mes_pt)).to eq("Março")
        expect(assigns(:ano)).to eq("2025")
      end
    end

    context "with multiple danfes in the same month" do
      let!(:danfe1) { create(:danfe, user: user, data_saida: Date.new(2025, 10, 5), valor: 1000.00) }
      let!(:danfe2) { create(:danfe, user: user, data_saida: Date.new(2025, 10, 15), valor: 2000.00) }
      let!(:danfe3) { create(:danfe, user: user, data_saida: Date.new(2025, 10, 25), valor: 1500.00) }

      it "returns all danfes for the month" do
        get month_receipts_url, params: { month: 10, year: 2025 }

        expect(assigns(:danfes).count).to eq(3)
        expect(assigns(:danfes)).to include(danfe1, danfe2, danfe3)
      end

      it "orders danfes by data_saida in descending order" do
        get month_receipts_url, params: { month: 10, year: 2025 }

        danfes = assigns(:danfes)
        expect(danfes.first).to eq(danfe3)  # Latest date (Oct 25)
        expect(danfes.last).to eq(danfe1)   # Earliest date (Oct 5)
      end
    end

    context "date range filtering" do
      let!(:first_day) { create(:danfe, user: user, data_saida: Date.new(2025, 10, 1), valor: 500.00) }
      let!(:last_day) { create(:danfe, user: user, data_saida: Date.new(2025, 10, 31), valor: 750.00) }
      let!(:next_month) { create(:danfe, user: user, data_saida: Date.new(2025, 11, 1), valor: 1000.00) }

      it "includes danfes from the first day of the month" do
        get month_receipts_url, params: { month: 10, year: 2025 }

        expect(assigns(:danfes)).to include(first_day)
      end

      it "includes danfes from the last day of the month" do
        get month_receipts_url, params: { month: 10, year: 2025 }

        expect(assigns(:danfes)).to include(last_day)
      end

      it "excludes danfes from other months" do
        get month_receipts_url, params: { month: 10, year: 2025 }

        expect(assigns(:danfes)).not_to include(next_month)
      end
    end

    context "available_months calculation" do
      let!(:jan_danfe) { create(:danfe, :january_2025, user: user) }
      let!(:feb_danfe) { create(:danfe, :february_2025, user: user) }
      let!(:oct_danfe) { create(:danfe, :october_2025, user: user) }

      it "calculates unique available months" do
        get month_receipts_url

        available_months = assigns(:available_months)
        expect(available_months).to be_an(Array)
        expect(available_months.size).to be >= 3
      end

      it "returns months in descending order" do
        get month_receipts_url

        available_months = assigns(:available_months)
        expect(available_months).to eq(available_months.sort.reverse)
      end
    end

    context "all Portuguese month names" do
      it "correctly translates January" do
        get month_receipts_url, params: { month: 1, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Janeiro")
      end

      it "correctly translates February" do
        get month_receipts_url, params: { month: 2, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Fevereiro")
      end

      it "correctly translates March" do
        get month_receipts_url, params: { month: 3, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Março")
      end

      it "correctly translates April" do
        get month_receipts_url, params: { month: 4, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Abril")
      end

      it "correctly translates May" do
        get month_receipts_url, params: { month: 5, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Maio")
      end

      it "correctly translates June" do
        get month_receipts_url, params: { month: 6, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Junho")
      end

      it "correctly translates July" do
        get month_receipts_url, params: { month: 7, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Julho")
      end

      it "correctly translates August" do
        get month_receipts_url, params: { month: 8, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Agosto")
      end

      it "correctly translates September" do
        get month_receipts_url, params: { month: 9, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Setembro")
      end

      it "correctly translates October" do
        get month_receipts_url, params: { month: 10, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Outubro")
      end

      it "correctly translates November" do
        get month_receipts_url, params: { month: 11, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Novembro")
      end

      it "correctly translates December" do
        get month_receipts_url, params: { month: 12, year: 2025 }
        expect(assigns(:mes_pt)).to eq("Dezembro")
      end
    end

    context "edge cases" do
      it "handles February in a leap year" do
        create(:danfe, user: user, data_saida: Date.new(2024, 2, 29), valor: 1000.00)

        get month_receipts_url, params: { month: 2, year: 2024 }

        expect(assigns(:danfes).count).to eq(1)
        expect(assigns(:selected_month)).to eq(Date.new(2024, 2, 1))
      end

      it "handles February in a non-leap year" do
        get month_receipts_url, params: { month: 2, year: 2023 }

        expect(assigns(:selected_month).end_of_month.day).to eq(28)
      end

      it "handles year boundaries correctly" do
        dec_2024 = create(:danfe, user: user, data_saida: Date.new(2024, 12, 31), valor: 1000.00)
        jan_2025 = create(:danfe, user: user, data_saida: Date.new(2025, 1, 1), valor: 2000.00)

        get month_receipts_url, params: { month: 12, year: 2024 }
        expect(assigns(:danfes)).to include(dec_2024)
        expect(assigns(:danfes)).not_to include(jan_2025)

        get month_receipts_url, params: { month: 1, year: 2025 }
        expect(assigns(:danfes)).to include(jan_2025)
        expect(assigns(:danfes)).not_to include(dec_2024)
      end

      it "handles string parameters correctly" do
        create(:danfe, user: user, data_saida: Date.new(2025, 5, 15), valor: 1000.00)

        get month_receipts_url, params: { month: "5", year: "2025" }

        expect(assigns(:danfes).count).to eq(1)
        expect(assigns(:mes_pt)).to eq("Maio")
      end
    end

    context "with different users" do
      let(:user2) { create(:user, email: "user2@example.com") }
      let!(:user1_danfe) { create(:danfe, user: user, data_saida: Date.new(2025, 10, 15)) }
      let!(:user2_danfe) { create(:danfe, user: user2, data_saida: Date.new(2025, 10, 15)) }

      it "shows all danfes regardless of user" do
        get month_receipts_url, params: { month: 10, year: 2025 }

        # Adjust this test based on your authorization logic
        # If the feature should filter by user, modify accordingly
        expect(assigns(:danfes).count).to eq(2)
      end
    end
  end

  describe "CRUD operations (not used in current implementation)" do
    # These routes exist but are not actively used in the feature
    # Including minimal tests for completeness

    describe "GET /show" do
      it "is defined but not used in the current feature" do
        # MonthReceipt model is empty, so we skip detailed tests
        skip "MonthReceipt CRUD operations are not part of the current feature"
      end
    end

    describe "GET /new" do
      it "is defined but not used in the current feature" do
        skip "MonthReceipt CRUD operations are not part of the current feature"
      end
    end

    describe "GET /edit" do
      it "is defined but not used in the current feature" do
        skip "MonthReceipt CRUD operations are not part of the current feature"
      end
    end

    describe "POST /create" do
      it "is defined but not used in the current feature" do
        skip "MonthReceipt CRUD operations are not part of the current feature"
      end
    end

    describe "PATCH /update" do
      it "is defined but not used in the current feature" do
        skip "MonthReceipt CRUD operations are not part of the current feature"
      end
    end

    describe "DELETE /destroy" do
      it "is defined but not used in the current feature" do
        skip "MonthReceipt CRUD operations are not part of the current feature"
      end
    end
  end
end
