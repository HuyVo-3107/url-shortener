class Api::ApiController < ApplicationController
  include ApplicationHelper
  before_action :authorize_request

  def authorize_request
    header_auth = request.headers['Authorization']
    if header_auth.present?
      header_auth = header_auth.split(' ')
      if header_auth[0] == "Bearer"
        decoded = Auth.decode(header_auth[1], ENV['JWT_ACCESS_TOKEN_PRIVATE_KEY'])
        p decoded
        @current_user = User.find(decoded[:user_id])
      elsif header_auth[0] == "PrivateToken"
        @current_user = User.find_by!(api_token_private: header_auth[1])
      else
        raise CustomError.new(401, "Authorization failed", 401)
      end
    else
      raise CustomError.new(401, "Authorization failed", 401)
    end
  end

  def index
    render json: {
        api_version: '1.0'
    }
  end

  def serializer active_record, **option
    option.length > 0 ? ActiveModelSerializers::SerializableResource.new(active_record, option) : ActiveModelSerializers::SerializableResource.new(active_record)
  end

  def pagination pagy
    {
        total: pagy.count,
        page: pagy.page,
        page_size: pagy.vars[:items].to_i,
        page_next: pagy.next,
        page_prev: pagy.prev,
        total_pages: pagy.pages
    }
  end
end
