class User < ApplicationRecord
  has_secure_password
  before_save{
    self.email = email.downcase
  }
  has_many :projects
  has_many :shared_projects
  validates_uniqueness_of :email
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :userid, :fullname, :password, presence: true, length: {minimum: 5} 
end
