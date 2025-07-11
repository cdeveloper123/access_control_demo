class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_one :parental_consent, dependent: :destroy

  # Virtual attributes for registration form
  attr_accessor :organization_id, :parent_email

  # Returns the user's age in years
  def age
    return unless date_of_birth
    ((Time.zone.today - date_of_birth) / 365.25).floor
  end

  # Returns the user's age group
  def age_group
    case age
    when 0..12 then 'child'
    when 13..17 then 'teen'
    else 'adult'
    end
  end
end
