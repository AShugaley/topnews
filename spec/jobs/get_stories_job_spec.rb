require 'rails_helper'

RSpec.describe GetStoriesJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_later }

  let(:story_ids_response) do
    [123]
  end

  let(:single_story_response) do
    {
      'id': 123,
      'title': 'Some Story',
      'url': 'www.some_url.com',
    }.to_json
  end

  let(:return_code) { 200 }

  before do
    stub_request(:get, GetStoriesJob::URL::HN_BEST_STORIES)
      .to_return(status: return_code, body: story_ids_response.to_s)

    stub_request(:get, GetStoriesJob::URL::HH_SINGLE_STORY::PREFIX + story_ids_response.first.to_s + GetStoriesJob::URL::HH_SINGLE_STORY::SUFFIX)
      .to_return(status: return_code, body: single_story_response)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { subject }.to have_enqueued_job(GetStoriesJob)
  end

  context 'when success' do
    it 'executes the job and creates stories' do
      perform_enqueued_jobs { subject }

      expect(Story.count).to eq(1)

      story = Story.first
      expect(story.title).to eq('Some Story')
      expect(story.url).to eq('www.some_url.com')
      expect(story.external_id).to eq(123)
    end
  end

  context 'when failed' do
    let(:return_code) { 500 }

    it 'handles API errors' do
      expect {
        perform_enqueued_jobs { described_class.perform_later }
      }.to raise_error

      expect(Story.count).to eq(0)
    end
  end
end
