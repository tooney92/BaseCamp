class Project < ApplicationRecord
  belongs_to :user
  has_many_attached :attachments
  has_many :topics
  has_many :shared_projects
  validates :title, :body,  presence: true
end
