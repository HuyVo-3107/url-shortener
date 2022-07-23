class Auth
  ALGORITHM = 'HS256'

  def self.encode(payload, secret, headers = { expire: payload[:expire], issue: request.host })
    JWT.encode(payload, secret, ALGORITHM, headers)
  end

  def self.decode(token, secret)
    begin
      body = JWT.decode(token, secret, true, {
          algorithm: ALGORITHM
      })[0]

      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature => exception
      raise JWT::ExpiredSignature, exception.message
    rescue JWT::DecodeError => exception
      raise JWT::DecodeError, exception.message
    rescue JWT::VerificationError => exception
      raise JWT::VerificationError, exception.message
    end
  end
end
