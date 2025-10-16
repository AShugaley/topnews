class Story < ApplicationRecord

  validates :title, presence: true
  validates :url, presence: true
  validates :external_id, presence: true, uniqueness: true

end