class User < ActiveRecord::Base
  has_secure_password
  has_many :recipes, dependent: :destroy

  before_validation :strip_leading_trailing_spaces, :ensure_auth_token

  validates_presence_of :email, :password_digest
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

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

  def strip_leading_trailing_spaces
    self.email = self.email.lstrip.rstrip unless self.email.nil?
  end
end
