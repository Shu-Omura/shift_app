FactoryBot.define do
  factory :collected_shift do
    started_at { Time.current + 1.day }
    finished_at { started_at + 1.hour }
    is_determined { [true, false].sample }
  end
end
