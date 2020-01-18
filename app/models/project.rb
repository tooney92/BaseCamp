class Project < ApplicationRecord
  belongs_to :user
  has_many_attached :attachments
  validates :title, :body,  presence: true
end
