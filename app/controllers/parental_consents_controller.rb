class ParentalConsentsController < ApplicationController
  def approve
    @parental_consent = ParentalConsent.find_by(consent_token: params[:token])
    
    if @parental_consent.nil?
      render :invalid_token and return
    end
    
    if @parental_consent.consent_granted?
      render :already_approved and return
    end
    
    # Approve the consent
    @parental_consent.grant_consent!
    @child = @parental_consent.user
    
    render :success
  end
end 