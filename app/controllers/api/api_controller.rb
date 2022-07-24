class Api::ApiController < ApplicationController
  include ApplicationHelper
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
