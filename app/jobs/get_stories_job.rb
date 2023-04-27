class GetStoriesJob < ApplicationJob
  queue_as :default

  module URL
    HN_BEST_STORIES = 'https://hacker-news.firebaseio.com/v0/beststories.json'

    module HH_SINGLE_STORY
      PREFIX = 'https://hacker-news.firebaseio.com/v0/item/'
      SUFFIX = '.json?print=pretty'
    end
  end

  def perform(*args)
    fetch_and_save_stories
  end

  private

  def fetch_and_save_stories
    story_ids = fetch_stories
    enrich_and_save_stories(story_ids)
  end

  def fetch_stories
    response = HTTParty.get(URL::HN_BEST_STORIES)

    if response.success?
      JSON.parse(response.body)
    else
      Rails.logger.error("Failed to fetch stories: #{response.code} - #{response.message}")
      raise "Failed to fetch stories - failing job"
    end
  end

  def enrich_and_save_stories(story_ids)
    story_ids.each do |story_id|
      fetch_and_store_story(story_id)
    end
  end

  def save_story(story_data)
    Story.find_or_create_by(external_id: story_data[:id]) do |story|
      story.title = story_data[:title]
      story.url = story_data[:url]
    end
  end
  
  def single_story_url(id)
    URL::HH_SINGLE_STORY::PREFIX + id.to_s + URL::HH_SINGLE_STORY::SUFFIX
  end
  
  def fetch_and_store_story(story_id)
    response = HTTParty.get(single_story_url(story_id))

    if response.success?
      save_story(JSON.parse(response.body).deep_symbolize_keys)
    else
      Rails.logger.error("Failed to fetch story with ID #{story_id}: #{response.code} - #{response.message}")
    end
  end
end
