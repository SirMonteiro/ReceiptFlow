# spec/support/auth_helpers.rb
module AuthHelpers
  include Rails.application.routes.url_helpers  # <-- adiciona acesso às rotas
  include ActionDispatch::Integration::Runner   # <-- adiciona o método `post`

  def sign_in(user)
    post sessions_path, params: { email: user.email, password: user.password }
  end
end
