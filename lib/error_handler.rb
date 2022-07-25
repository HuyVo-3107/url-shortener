module ErrorHandler
  class CustomError < StandardError
    attr_reader :options, :code, :status, :message

    def initialize(code = 500, options = {}, status = 500)
      super()
      @status = status
      @code = code
      @options = options

      if options.is_a? Hash
        @message = options['message'] || ''
      else
        @message = options
      end
    end
  end

  class PagyVariableError
    attr_reader :error

    def initialize error
      @pagy = error.pagy
      @variable = error.variable
      @value = error.value
    end

    def to_hash
      {
          status: 400,
          errors: [
              {
                  resource: "pagination",
                  message: "page=" + @value.to_s + " don't exist",
                  code: 400
              }
          ]
      }
    end
  end

  def self.included(clazz)
    clazz.class_eval do

      rescue_from StandardError do |exception|
        responds(402, exception.as_json, 400)
      end

      rescue_from CustomError do |exception|
        responds exception.code, exception.options, exception.status
      end

      rescue_from JWT::ExpiredSignature do |exception|
        responds(401, exception, 401)
      end

      rescue_from JWT::DecodeError do |exception|
        responds(401, exception, 401)
      end

      rescue_from JWT::VerificationError do |exception|
        responds(401, exception, 401)
      end

      rescue_from Pagy::VariableError, with: :render_pagy_error
    end
  end

  private

  def render_pagy_error error
    render json: PagyVariableError.new(error).to_hash, status: 200 and nil
  end

  def responds code, message, status
    render json: {
        status: code,
        errors: {
            message: message,
            code: code,
            request_id: request.request_id
        }
    }, status: status and return
  end
end
