class UsersController < ApplicationController
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Usuário cadastrado com sucesso!"
      redirect_to new_user_path
    else
      flash.now[:alert] = "Erro ao cadastrar usuário. Verifique os campos."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nome, :email, :password, :password_confirmation)
  end
end
