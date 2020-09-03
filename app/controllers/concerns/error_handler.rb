module ErrorHandler
  extend ActiveSupport::Concern

  def render_errors(data, status = :unprocessable_entity)
    json = if data.is_a? String
             { message: data }
           else
             { errors: data.errors, message: data.errors.full_messages.join(' / ') }
           end
    render json: json, status: status
  end
end
