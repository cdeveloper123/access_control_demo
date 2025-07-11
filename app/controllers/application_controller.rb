class ApplicationController < ActionController::Base
  # Configure Devise to permit name parameter
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :date_of_birth])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :date_of_birth])
  end

  # Access control helper methods
  def current_membership
    return nil unless user_signed_in?
    current_user.memberships.first
  end

  def current_organization
    current_membership&.organization
  end

  def admin?
    current_membership&.admin?
  end

  def moderator?
    current_membership&.moderator?
  end

  def member?
    current_membership&.member?
  end

  def moderator_or_admin?
    current_membership&.moderator? || current_membership&.admin?
  end

  def age_blocked?
    return false unless current_user&.age && current_user.age < 13
    
    parental_consent = current_user.parental_consent
    return true if parental_consent.nil?
    
    !parental_consent.consent_granted?
  end

  # Make these methods available in views
  helper_method :current_membership, :current_organization, :admin?, :moderator?, :member?, :moderator_or_admin?, :age_blocked?
end
