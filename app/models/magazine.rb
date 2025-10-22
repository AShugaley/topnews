class Magazine < Readable
  has_and_belongs_to_many :authors
  validates :published_at, presence: true

  def print_details
    puts super + " | published_at: #{published_at}"
  end
end
