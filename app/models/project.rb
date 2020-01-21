class Project < ApplicationRecord
  belongs_to :user
  has_many_attached :attachments
  has_many :topics
  validates :title, :body,  presence: true
end
