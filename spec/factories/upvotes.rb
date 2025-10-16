FactoryBot.define do
  factory :upvote do
    association :story
    association :user
  end
end
