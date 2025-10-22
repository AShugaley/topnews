class Readable < ApplicationRecord
  self.abstract_class = true

  validates :title, presence: true
  validates :isbn, presence: true, uniqueness: true

  def print_details
    "Type: #{self.class} | title: #{self.title} | isbn: #{self.isbn} | authors: #{ authors_names}"
  end

  def self.isbn_lookup(isbn)
    puts self.class.find(isbn: isbn)&.print_details
  end

  def self.print_all
    subclasses.each do |klass|
      puts "#{klass.name}:"
      klass.all.each do |readable|
        puts readable.print_details
      end
    end
  end

  def self.print_by_title
    all_readables.sort_by(&:title).each { |readable| readable.print_details }
  end

  private

  def authors_names
    authors.map { |a| "#{a.first_name} #{a.last_name}" }.join(", ")
  end
  def self.all_readables
    @all_readables ||= subclasses.flat_map(&:all)
  end
end
