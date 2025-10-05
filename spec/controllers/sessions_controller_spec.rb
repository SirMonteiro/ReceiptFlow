require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { build_stubbed(:user, email: "teste@example.com", password: "senha123") }

  describe "GET #new" do
    it "renderiza a tela de login" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "quando as credenciais são válidas" do
      before do
        allow(User).to receive(:find_by).with(email: user.email).and_return(user)
        allow(user).to receive(:authenticate).with("senha123").and_return(user)
      end

      it "loga o usuário e redireciona para root_path" do
        post :create, params: { email: user.email, password: "senha123" }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Login realizado com sucesso!")
      end
    end

    context "quando a senha é inválida" do
      before do
        allow(User).to receive(:find_by).with(email: user.email).and_return(user)
        allow(user).to receive(:authenticate).with("senha_errada").and_return(false)
      end

      it "não loga e renderiza new novamente" do
        post :create, params: { email: user.email, password: "senha_errada" }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("Email ou senha inválidos")
      end
    end

    context "quando o usuário não existe" do
      before do
        allow(User).to receive(:find_by).with(email: "inexistente@example.com").and_return(nil)
      end

      it "não loga e renderiza new novamente" do
        post :create, params: { email: "inexistente@example.com", password: "senha123" }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("Email ou senha inválidos")
      end
    end
  end
end
