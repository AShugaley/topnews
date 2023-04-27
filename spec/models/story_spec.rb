require 'rails_helper'

RSpec.describe Story, type: :model do
  describe "validations" do
    it "is valid with a title and url" do
      story = FactoryBot.build(:story)
      expect(story).to be_valid
    end

    it "is invalid without a title" do
      story = FactoryBot.build(:story, title: nil)
      expect(story).not_to be_valid
    end

    it "is invalid without a url" do
      story = FactoryBot.build(:story, url: nil)
      expect(story).not_to be_valid
    end
  end

  describe "associations" do
    it "has many upvotes" do
      story = FactoryBot.create(:story)
      upvote1 = FactoryBot.create(:upvote, story: story)
      upvote2 = FactoryBot.create(:upvote, story: story)
      expect(story.upvotes).to match_array([upvote1, upvote2])
    end

    it "has many upvoters" do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      story = FactoryBot.create(:story)
      upvote1 = FactoryBot.create(:upvote, story: story, user: user1)
      upvote2 = FactoryBot.create(:upvote, story: story, user: user2)
      expect(story.upvotes.first.user.id).to match(user1.id)
    end
  end
end
