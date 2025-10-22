class Author < ApplicationRecord
  has_and_belongs_to_many :books
  has_and_belongs_to_many :magazines

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def all_works
    books + magazines
  end

  def self.find_works_by_email(email)
    find_by(email: email)&.all_works.each { |work| puts work.print_details }
  end
end