FactoryBot.define do
  factory :attendance do
    started_at { Time.current - 1.day }
    sequence(:finished_at) { |n| started_at + n.minutes }
  end
end
