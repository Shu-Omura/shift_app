FactoryBot.define do
  factory :user do
    name                  { 'Example User' }
    sequence(:email)      { |n| "example#{n + 1}@use.com" }
    password              { 'foobar' }
    password_confirmation { 'foobar' }
    confirmed_at          { Time.current }

    factory :fixed_user do
      email { "fixed@user.com" }
    end
  end
end
