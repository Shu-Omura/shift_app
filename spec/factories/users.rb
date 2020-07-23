FactoryBot.define do
  factory :user do
    name                  { 'Example User' }
    sequence(:email)      { |n| "example#{n + 1}@user.com" }
    password              { 'password' }
    password_confirmation { 'password' }
    company

    factory :admin_user do
      admin { true }
    end
  end
end
