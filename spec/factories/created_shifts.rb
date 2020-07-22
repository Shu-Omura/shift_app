FactoryBot.define do
  factory :created_shift do
    started_at { Time.current + 1.day }
    finished_at { started_at + 1.hour }
  end
end
