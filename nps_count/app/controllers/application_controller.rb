class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  def render_bad_request(exception)
    render json: { error_message: exception.message }, status: :bad_request
  end
end
