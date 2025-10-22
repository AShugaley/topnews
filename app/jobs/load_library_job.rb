require 'csv'

class LoadLibraryJob < ApplicationJob
  queue_as :default

  module PATH
    DIR = '/Users/shugaley/dev/topnews/lib/bookdata/'
    AUTHORS = DIR + 'authors.csv'
    BOOKS = DIR + 'books.csv'
    MAGAZINES = DIR + 'magazines.csv'
  end

  def perform(*args)
    require 'csv'

    load_authors
    load_books
    load_magazines
  end

  private

  def load_authors
    CSV.foreach(PATH::AUTHORS,
                headers: true,
                col_sep: ';',
                encoding: 'UTF-8') do |row|

      author = Author.find_or_create_by(email: row['email']) do |a|
        a.first_name = row['firstname']
        a.last_name = row['lastname']
      end

      if author.previously_new_record?
        puts "✓ Created: #{author.last_name}"
      else
        puts "→ Already exists: #{author.last_name}"
      end
    end
  end

  def load_books
    CSV.foreach(PATH::BOOKS,
                headers: true,
                col_sep: ';',
                encoding: 'bom|utf-8') do |row|
      author_emails = row['authors'].split(',').map(&:strip)
      authors = Author.where(email: author_emails)

      # Create or update book
      book = Book.find_or_create_by!(isbn: row['isbn']) do |b|
        b.title = row['title']
        b.description = row['description']
      end

      # Associate authors
      book.authors = authors

      puts book.previously_new_record? ? "✓ Created: #{book.title}" : "→ Already exists: #{book.title}"
    end
  end

  def load_magazines
    CSV.foreach(PATH::MAGAZINES,
                headers: true,
                col_sep: ';',
                encoding: 'bom|utf-8') do |row|
      author_emails = row['authors'].split(',').map(&:strip)
      authors = Author.where(email: author_emails)

      # Create or update book
      magazine = Magazine.find_or_create_by!(isbn: row['isbn']) do |m|
        m.title = row['title']
        m.published_at = row['publishedAt']
      end

      # Associate authors
      magazine.authors = authors

      puts magazine.previously_new_record? ? "✓ Created: #{magazine.title}" : "→ Already exists: #{magazine.title}"
    end
  end
end
