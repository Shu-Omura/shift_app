FactoryBot.define do
  factory :collected_shift do
    started_at { Time.current.since(1.day) }
    finished_at { started_at.since(1.hour) }
    is_determined { [true, false].sample }

    factory :determined_shift do
      is_determined { true }
      user
    end

    factory :non_determined do
      is_determined { false }
    end

    factory :collected_shift_2 do
      started_at { Time.current.since(2.days) }
      finished_at { Time.current.since(2.days).since(1.hour) }
    end
  end
end
