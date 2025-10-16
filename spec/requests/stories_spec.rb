require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let(:user) { create(:user) }
  # let!(:story) { create(:story) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns the stories" do
      story1 = FactoryBot.create(:story)
      story2 = FactoryBot.create(:story)
      get :index
      expect(assigns(:stories)).to match_array([story1, story2])
    end
  end

  describe 'POST #upvote' do
    context "with valid params" do
      let!(:story) { FactoryBot.create(:story) }

      before do
        post :upvote, params: { id: story.id }
      end

      it "upvotes the story for the current user" do
        expect(story.upvotes.find_by(user_id: user.id)).not_to be_nil
      end

      it "redirects to the stories index page" do
        expect(response).to redirect_to(stories_path)
      end
    end

    context "with invalid params" do
      it "raises a RecordNotFound error" do
        expect {
          post :upvote, params: { id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #upvoted" do
    it "returns a successful response" do
      get :upvoted
      expect(response).to be_successful
    end

    it "assigns the upvoted stories" do
      story1 = FactoryBot.create(:story)
      story2 = FactoryBot.create(:story)
      upvote1 = FactoryBot.create(:upvote, story: story1)
      upvote2 = FactoryBot.create(:upvote, story: story2)
      get :upvoted
      expect(assigns(:upvoted_stories)).to match_array([story1, story2])
    end

    it "orders the upvoted stories by number of upvotes" do
      story1 = FactoryBot.create(:story)
      story2 = FactoryBot.create(:story)
      upvote1 = FactoryBot.create(:upvote, story: story1)
      upvote2 = FactoryBot.create(:upvote, story: story1)
      upvote3 = FactoryBot.create(:upvote, story: story2)
      get :upvoted
      expect(assigns(:upvoted_stories)).to eq([story1, story2])
    end
  end
end
