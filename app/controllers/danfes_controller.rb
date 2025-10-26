class DanfesController < ApplicationController
    before_action :require_login, only: [:home]
    def index
        @danfes = current_user.danfes.order(created_at: :desc)
    end
end