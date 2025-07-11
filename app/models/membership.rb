class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, { member: 0, moderator: 1, admin: 2 }

  validates :user_id, uniqueness: { scope: :organization_id }
end
