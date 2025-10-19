class DanfesController < ApplicationController
    before_action :authenticate_user! # NAO SEI SE FUNCIONA

    def index
        @danfes = current_user.danfes.order(created_at: :desc)
    end
end