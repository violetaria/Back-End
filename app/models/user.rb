class User < ActiveRecord::Base
  has_secure_password

  before_validation :ensure_auth_token

  validates_presence_of :email, :password_digest
  validates_uniqueness_of :email

  def ensure_auth_token
    if self.auth_token.blank?
      self.auth_token = User.generate_token
    end
  end

  def self.generate_token
    token = SecureRandom.hex
    while User.exists?(auth_token: token)
      token = SecureRandom.hex
    end
    token
  end
end
