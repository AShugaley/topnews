require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:upvoted_story) { create(:story) }

  before do
    user.upvote_story(upvoted_story)
    sign_in user
  end

  describe 'GET #show' do
    it 'assigns the requested user as @user and shows their upvoted stories' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
      expect(assigns(:upvoted_stories)).to eq([upvoted_story])
    end
  end
end
