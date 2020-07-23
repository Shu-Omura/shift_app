FactoryBot.define do
  factory :attendance do
    started_at { Time.current.ago(1.day) }
    sequence(:finished_at) { |n| started_at.since(n.minutes) }
  end
end
