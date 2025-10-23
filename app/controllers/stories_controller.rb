class StoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @stories = Story.order(created_at: :desc).page(params[:page]).per(20)
  end

  def upvote
    story = Story.find(params[:id])
    current_user.upvote_story(story)

    redirect_to stories_path
  end

  def downvote
    story = Story.find(params[:id])
    current_user.downvote_story(story)

    redirect_to stories_path
  end

  def upvoted
    @users = User.order(:email)


    scope = Story.select('stories.*, COUNT(upvotes.id) AS upvotes_count')
                 .joins(:upvotes)

    scope = scope.where(upvotes: { user_id: params[:user_id] }) if params[:user_id].present? && params[:user_id] != 'all'

    @upvoted_stories = scope.group('stories.id')
                            .order('upvotes_count DESC')
                            .page(params[:page])
                            .per(20)
  end

  def refresh
    Story.refresh_stories

    redirect_to stories_path
  end

  def search
    @search_param = params[:search_term]
    @stories = Story.search(@search_param).page(params[:page]).per(20)

    redirect_to stories_path, alert: "Story not found" if @stories.empty?
  end
end



#test