class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project
  validates :task,  presence: true
end
