5.times do |i|
  User.create!(
    name: "Sample User#{i+1}",
    email: "example#{i+1}@user.com",
    password: "foobar",
    password_confirmation: "foobar",
    created_at: Time.current,
  )
end
