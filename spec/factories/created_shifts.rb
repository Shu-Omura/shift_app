FactoryBot.define do
  factory :created_shift do
    started_at { Time.current.since(1.day) }
    finished_at { started_at.since(1.hour) }
  end
end
