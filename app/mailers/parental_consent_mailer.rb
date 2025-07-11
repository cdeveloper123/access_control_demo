class ParentalConsentMailer < ApplicationMailer
  default from: 'noreply@accesscontrol.demo'

  def consent_request(parental_consent)
    @parental_consent = parental_consent
    @user = parental_consent.user
    @parent_email = parental_consent.parent_email
    @consent_url = consent_approval_url(@parental_consent.consent_token)
    @child_name = @user.name
    @child_age = @user.age
    @organization = @user.memberships.first&.organization&.name || "Our Platform"

    mail(
      to: @parent_email,
      subject: "Parental Consent Required for #{@child_name}'s Account"
    )
  end

  private

  def consent_approval_url(token)
    Rails.application.routes.url_helpers.approve_consent_url(token: token, host: 'localhost:3000')
  end
end 