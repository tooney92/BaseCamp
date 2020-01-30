class Topic < ApplicationRecord
    has_many :messages, dependent: :destroy
    belongs_to :project
    validates :title, presence: true
end
