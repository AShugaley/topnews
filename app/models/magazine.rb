class Magazine < Readable
  has_and_belongs_to_many :authors
  validates :published_at, presence: true

  def self.isbn_lookup(isbn)
    require 'pry' ; binding.pry
    puts self.find(isbn: isbn)&.print_details
  end

  def print_details
    super + " | published_at: #{published_at}"
  end
end
