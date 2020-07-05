5.times do |i|
  User.create!(
    name: "yamada#{i} taro",
    email: "example#{i}@gmail.com",
    password: "foobar",
    password_confirmation: "foobar",
    company_id: 1,
    confirmed_at: DateTime.new(2020, 01, 01, 12, 0)
    )
end
  
5.times do |i|
  User.create!(
    name: "yamada#{i+5} taro",
    email: "example#{i+5}@gmail.com",
    password: "foobar",
    password_confirmation: "foobar",
    company_id: 2,
    confirmed_at: DateTime.new(2020, 01, 01, 12, 0)
    )
end
    
3.times do |i|
  User.all.each do |user|
    user.collected_shifts.create(started_at: DateTime.new(2021, 01, i+1, 12, 0), finished_at: DateTime.new(2021, 01, i+1, 18, 0))
  end
end

CollectedShift.first.update(is_determined: true)