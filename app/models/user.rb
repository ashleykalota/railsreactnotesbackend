class User < ApplicationRecord
  has_secure_password
  has_many :billings

  enum role: { admin: 0, dispatcher: 1, driver: 2, guest: 3 }


  # Optional: Add validation for role if necessary
  validates :role, inclusion: { in: roles.keys }
  validates :password, length: { minimum: 6 }, on: [:create, :update], if: -> { password.present? }
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[admin driver guest] }
  validates :name, presence: true
 
end
