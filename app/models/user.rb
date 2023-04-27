class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :upvotes
  has_many :upvoted_stories, through: :upvotes, source: :story

  def upvote_story(story)
    upvotes.create(story: story)
  end
end
