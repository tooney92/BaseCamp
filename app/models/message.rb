class Message < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  validates :message, presence: true
end
