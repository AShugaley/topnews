class Book < Readable
  has_and_belongs_to_many :authors

  def print_details
    super + " | description: #{description}"
  end
end
