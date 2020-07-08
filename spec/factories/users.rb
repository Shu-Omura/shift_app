FactoryBot.define do
  factory :user do
    name                  { "Example User" }
    sequence(:email)      { |n| "example#{n + 1}@use.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }
    company_id { 1 }

    factory :fixed_user do
      email { "fixed@user.com" }
    end

    factory :admin_user do
      admin { true }
    end
  end
end
