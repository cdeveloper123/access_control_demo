class ParticipationArea < ApplicationRecord
  belongs_to :organization

  validates :title, presence: true
  validates :content, presence: true
  validates :min_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_age, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :max_age_greater_than_min_age

  scope :for_age, ->(age) { where('min_age <= ? AND max_age >= ?', age, age) }
  scope :for_organization, ->(organization_id) { where(organization_id: organization_id) }

  private

  def max_age_greater_than_min_age
    return unless min_age && max_age
    
    errors.add(:max_age, "must be greater than or equal to minimum age") if max_age < min_age
  end
end
