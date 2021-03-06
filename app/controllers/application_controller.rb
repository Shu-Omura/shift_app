class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation, :remember_me, :company, :company_auth_token]
    update_attrs = [:name, :password, :password_confirmation, :remember_me, :company, :company_auth_token]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  def admin_user
    redirect_back(fallback_location: root_url) unless current_user.admin?
  end

  def check_company
    redirect_to root_url unless current_user.company
  end
end
