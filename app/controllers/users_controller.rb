class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Usuário cadastrado com sucesso!"
      redirect_to new_session_path
    else
      flash[:alert] = "Erro ao cadastrar usuário. Verifique os campos."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation)
  end
end
