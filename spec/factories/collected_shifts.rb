FactoryBot.define do
  factory :collected_shift do
    started_at { Time.current }
    finished_at { Time.current + 1.day }
    user
  end
end
