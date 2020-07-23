User.create!(
  name: 'Test User',
  email: 'sample@test.com',
  password: 'foobar',
  password_confirmation: 'foobar',
)

user = User.first
user.create_company!(name: 'Company')
user.update!(admin: true)

4.times do |i|
  name = Faker::Name.name
  email = "sample-#{i+1}@rtest.com"
  password = 'foobar'
  company = Company.last
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    company: company,
  )
end

User.all.each_with_index do |user, index|
  3.times do |i|
    num = index + i + 1
    user.collected_shifts.create!(
      started_at: Time.current.since((num).days),
      finished_at: Time.current.since((num).days).since(8.hours),
    )
    user.attendances.create!(
      started_at: Time.current.ago(num.days),
      finished_at: Time.current.ago((num).days).since(8.hours),
    )
  end
end

CollectedShift.first(5).each do |shift|
  shift.create_created_shift(
    started_at: shift.started_at,
    finished_at: shift.finished_at,
  )
end
