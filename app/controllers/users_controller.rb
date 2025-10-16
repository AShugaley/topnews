class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @upvoted_stories = @user.upvoted_stories
  end
end
