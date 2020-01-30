class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many_attached :attachments
  has_many :topics, dependent: :destroy
  has_many :shared_projects, dependent: :destroy
  validates :title, :body,  presence: true
end
