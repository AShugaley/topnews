FactoryBot.define do
  factory :story do
    title { ::Faker::Lorem.word }
    url { "https://example.com" }
    external_id { ::Faker::Number.binary(digits: 10) }
  end
end
