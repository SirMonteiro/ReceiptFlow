# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    context 'quando os dados são válidos' do
      it 'chama o método do modelo para criar um novo usuário' do
        user_params = {
          'nome' => 'Matheus',
          'email' => 'teste@example.com',
          'password' => '123456'
        }

        fake_user = double('User')
        expect(User).to receive(:new).with(hash_including(user_params)).and_return(fake_user)
        allow(fake_user).to receive(:save).and_return(true)

        post :create, params: { user: user_params }
      end

      it 'deve atribuir o usuário criado e redirecionar para login' do
        fake_user = double('User')
        allow(User).to receive(:new).and_return(fake_user)
        allow(fake_user).to receive(:save).and_return(true)

        post :create, params: { user: { nome: 'Teste', email: 'teste@example.com', password: '123456' } }

        expect(assigns(:user)).to eq(fake_user)
        expect(response).to redirect_to(new_session_path)
        expect(flash[:notice]).to eq('Usuário cadastrado com sucesso!')
      end
    end

    context 'quando os dados são inválidos' do
      it 'não deve salvar e deve renderizar o template new' do
        fake_user = double('User')
        allow(User).to receive(:new).and_return(fake_user)
        allow(fake_user).to receive(:save).and_return(false)

        post :create, params: { user: { nome: '', email: '', password: '' } }

        expect(assigns(:user)).to eq(fake_user)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Erro ao cadastrar usuário. Verifique os campos.')
      end
    end
  end
end
