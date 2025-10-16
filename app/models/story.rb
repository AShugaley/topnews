class Story < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true
  validates :external_id, presence: true, uniqueness: true

  has_many :upvotes
  has_many :upvoted_by_users, through: :upvotes, source: :user
end
