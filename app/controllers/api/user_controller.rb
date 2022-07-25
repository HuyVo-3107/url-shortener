class Api::UserController < Api::ApiController

  def user_info
    render json: {
        status: 200,
        data: {
            user: serializer(@current_user, each_serializer: UserSerializer),
        }
    }
  end

  def update
    name = params[:name]
    @current_user.name = name
    if @current_user.save!
      render json: {
          status: 200,
          data: {
              user: serializer(@current_user, each_serializer: UserSerializer),
          }
      }
    end
  end

  def generate_api_token
    @current_user.regenerate_api_token_private
    @current_user.reload
    render json: {
        status: 200,
        data: {
            token: @current_user.api_token_private
        }
    }
  end

end