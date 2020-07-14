FactoryBot.define do
  factory :working_result do
    user { nil }
    term { '2020-07-09' }
    total_time { 1 }
    total_wage { 1 }
  end
end
