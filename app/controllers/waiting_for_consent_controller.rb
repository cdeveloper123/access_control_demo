class WaitingForConsentController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_consent_required

  def index
    @user = current_user
    @parental_consent = @user.parental_consent
  end

  def resend_email
    @user = current_user
    @parental_consent = @user.parental_consent
    
    if @parental_consent.nil?
      redirect_to waiting_for_consent_path, alert: "No parental consent record found."
      return
    end
    
    if @parental_consent.consent_given_at.present?
      redirect_to dashboard_path, notice: "Consent has already been granted!"
      return
    end
    
    # Send the consent email
    ParentalConsentMailer.consent_request(@parental_consent).deliver_now
    
    redirect_to waiting_for_consent_path, notice: "Consent email has been resent to #{@parental_consent.parent_email}"
  end

  private

  def ensure_consent_required
    # Redirect users who don't need consent or already have it
    unless age_blocked?
      redirect_to dashboard_path, notice: "You already have access to the platform."
    end
  end
end
