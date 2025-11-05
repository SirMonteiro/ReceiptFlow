# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: 'Login realizado com sucesso!'
    else
      flash.now[:alert] = 'Email ou senha inválidos'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: 'Logout realizado com sucesso!'
  end
end
