require "rails_helper"

RSpec.describe User, type: :model do
  it "has valid factory" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is not valid without name" do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it "is not valid without email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "is not valid with duplicated email" do
    user = create(:user, email: "fixed-email@user.com")
    dup_user = build(:user, email: "fixed-email@user.com")
    expect(dup_user).not_to be_valid
  end

  it "is not valid without password" do
    user = build(:user, password: nil, password_confirmation: nil)
    expect(user).not_to be_valid
  end

  it "is valid with password, length beteween 6 and 128" do
    user = build(:user, password: "a" * 5, password_confirmation: "a" * 5)
    expect(user).not_to be_valid
    user = build(:user, password: "a" * 6, password_confirmation: "a" * 6)
    expect(user).to be_valid
    user = build(:user, password: "a" * 128, password_confirmation: "a" * 128)
    expect(user).to be_valid
    user = build(:user, password: "a" * 129, password_confirmation: "a" * 129)
    expect(user).not_to be_valid
  end
end
