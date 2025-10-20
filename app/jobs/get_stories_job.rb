class GetStoriesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Story.refresh_stories
  end
end
