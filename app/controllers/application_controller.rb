class ApplicationController < ActionController::API
    def success_response
        render json: { }
    end
end
