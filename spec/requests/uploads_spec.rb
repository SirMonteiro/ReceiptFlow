# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Uploads', type: :request do
  let(:user) { create(:user) }

  describe 'GET /uploads/new' do
    context 'when not authenticated' do
      it 'redirects to the login page' do
        get new_upload_path

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when authenticated' do
      it 'responds with success' do
        sign_in(user)

        get new_upload_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Enviar Arquivo XML')
      end
    end
  end

  describe 'POST /uploads' do
    context 'when authenticated' do
      before { sign_in(user) }

      it 'accepts an XML file and redirects to the dashboard' do
        xml_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/receipt.xml'), 'text/xml')

        post uploads_path, params: { upload: { xml_file: xml_file } }

        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(root_path)
      end

      it 'redirects with an alert when the payload is missing' do
        post uploads_path

        expect(response).to redirect_to(new_upload_path)
        follow_redirect!
        expect(response.body).to include('Por favor, selecione um arquivo')
      end
    end

    context 'when not authenticated' do
      it 'redirects to the login page' do
        post uploads_path

        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
