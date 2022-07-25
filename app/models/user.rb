class User < ApplicationRecord
  attribute :password
  attribute :password_confirmation

  has_secure_password
  has_secure_token :api_token_private

  validates :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true, presence: true, length: {minimum: 6}, on: :create
  validates :password_confirmation, presence: true, on: :update, if: Proc.new { |u| u.password_confirmation.present? }
  validates :password, confirmation: true, presence: true, length: {minimum: 6}, on: :update, if: Proc.new { |u| u.password.present? }

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  validates :name, presence: true

  has_many :links, dependent: :destroy

  def change_password password, confirmation
    self.update!(password: password, password_confirmation: confirmation)
  end
end
