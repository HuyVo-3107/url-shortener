class Api::ApiController < ApplicationController
  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = Auth.decode(header, ENV['JWT_ACCESS_TOKEN_PRIVATE_KEY'])
    p decoded
    @current_user = User.find(decoded[:user_id])

  end

  def index
    render json: {
        api_version: '1.0'
    }
  end
end
