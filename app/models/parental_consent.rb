class ParentalConsent < ApplicationRecord
  belongs_to :user

  before_create :generate_consent_token

  def consent_granted?
    consent_given_at.present?
  end

  def grant_consent!
    update!(consent_given_at: Time.current)
  end

  private

  def generate_consent_token
    self.consent_token ||= SecureRandom.hex(10)
  end
end
