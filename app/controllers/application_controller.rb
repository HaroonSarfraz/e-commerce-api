# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ErrorHandler
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
  # protect_from_forgery with: :null_session, if: :verify_api
  protect_from_forgery unless: -> { request.format.json? }
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name subdomain phone_no])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || rails_admin_path
  end

  private

  def user_not_authorized
    render json: { message: 'You are not authorized to perform this action.' },
           status: :unprocessable_entity
  end
end
