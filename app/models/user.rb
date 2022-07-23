class User < ApplicationRecord
  attribute :password
  attribute :password_confirmation

  has_secure_password

  validates :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true, presence: true, length: {minimum: 6}, on: :create
  validates :password_confirmation, presence: true, on: :update, if: Proc.new { |u| u.password_confirmation.present? }
  validates :password, confirmation: true, presence: true, length: {minimum: 6}, on: :update, if: Proc.new { |u| u.password.present? }

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  validates :name, presence: true

  has_many :links

end
