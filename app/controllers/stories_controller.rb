class StoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @stories = Story.page(params[:page]).per(20)
  end

  def upvote
    story = Story.find(params[:id])
    current_user.upvote_story(story)

    redirect_to stories_path
  end

  def upvoted
    @upvoted_stories = Story.select('stories.*, COUNT(upvotes.id) AS upvotes_count')
                            .joins(:upvotes)
                            .group('stories.id')
                            .order('upvotes_count DESC')
                            .page(params[:page]).per(20)
  end
end
