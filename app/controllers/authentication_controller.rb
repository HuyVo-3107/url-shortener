class AuthenticationController < ApplicationController
  def login
    ApplicationRecord.transaction do
      user = User.find_by(email: params[:email])
      p user
      raise CustomError.new(404, "User email is not exits", 200) unless user.present?
      # Equal password
      if user.authenticate(params[:password])
        payload = {
            user_id: user.id,
            email: user.email,
            expire: (1.hours.from_now + 10.seconds).to_i
        }

        # perform generate access_token
        access_token = Auth.encode(
            payload,
            ENV['JWT_ACCESS_TOKEN_PRIVATE_KEY'],
            {
                expire: payload[:expire]
            }
        )

        refresh_token = user.refresh_token
        refresh_token_expire = user.refresh_token_expire

        if !refresh_token.present? || (refresh_token_expire.to_i < DateTime.now.utc.to_i)
          refresh_token_expire = 1.days.from_now.freeze
          refresh_token = Auth.encode(
              payload,
              ENV['JWT_REFRESH_TOKEN_PRIVATE_KEY'],
              {
                  expire: refresh_token_expire
              }
          )
          user.update!(
              refresh_token: refresh_token,
              refresh_token_expire: refresh_token_expire
          )
        end
        render json: {
            data: {
                access_token: access_token,
                access_exp: payload[:expire],
                refresh_token: refresh_token,
                refresh_exp: refresh_token_expire.to_i
            },
            status: 200
        }, status: :created and return
      else
        raise CustomError.new(404, "Login failed! Password incorrect", 200)
      end
    end
  end


  # ************************************
  # Description: renew access token by refresh token
  # ************************************
  #
  def refresh_token
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
    else
      raise CustomError.new(401, "Request invalid. Refresh_token is null", 401)
    end
    decoded = Auth.decode(token, ENV['JWT_REFRESH_TOKEN_PRIVATE_KEY'])
    user = User.find(decoded[:user_id])

    raise CustomError.new(401, "Request invalid. Refresh_token don't match", 401) if user.refresh_token != token
    payload = {
        user_id: user.id,
        email: user.email,
        expire: (1.hours.from_now + 10.seconds).to_i
    }

    # perform generate access_token
    access_token = Auth.encode(
        payload,
        ENV['JWT_ACCESS_TOKEN_PRIVATE_KEY'],
        {
            expire: payload[:expire]
        }
    )

    render json: {
        data: {
            access_token: access_token,
            access_exp: payload[:expire]
        },
        status: 200
    }, status: :created
  end


  # ************************************
  # Description: Register User with email, password, user_name
  # ************************************
  #
  def register
    ApplicationRecord.transaction do
      strong_params = params.permit(:email, :name, :password, :password_confirmation)
      ApplicationRecord.transaction do
        user = User.create!(strong_params)

        access_token_expire = 1.hours.from_now

        payload = {
            user_id: user.id,
            email: user.email,
            expire: (1.hours.from_now + 10.seconds).to_i
        }

        # generate access token
        access_token = Auth.encode(payload, ENV['JWT_ACCESS_TOKEN_PRIVATE_KEY'], {exp: (access_token_expire + 10.seconds).to_i})

        # generate refresh token
        refresh_token_expire = 1.days.from_now.freeze
        refresh_token = Auth.encode(payload, ENV['JWT_REFRESH_TOKEN_PRIVATE_KEY'], {exp: refresh_token_expire.to_i})

        render json: {
            data: {
                access_token: access_token,
                access_exp: access_token_expire.to_i,
                refresh_token: refresh_token,
                refresh_exp: refresh_token_expire.to_i
            },
            status: 200
        }, status: :created
      end
    end
  end

end
