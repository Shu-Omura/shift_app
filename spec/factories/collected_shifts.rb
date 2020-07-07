FactoryBot.define do
  factory :collected_shift do
    started_at { Time.current }
    finished_at { DateTime.new(2030, 1, 1, 12, 0, 0) }
    is_determined { true }
    user
  end
end
