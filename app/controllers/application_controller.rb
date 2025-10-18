class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    private

    # retorna o user logado
    def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    # retorna true se o user estiver logado
    def logged_in?
        current_user.present?
    end

    def authenticate_user!
        unless current_user
            redirect_to new_session_path, alert: "Você precisa fazer login primeiro."
        end
    end

end
