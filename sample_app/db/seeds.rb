User.destroy_all

User.create!(name:  "Pep Merc",
             email: "buddylee939@hotmail.com",
             password:              "asdfasdf",
             password_confirmation: "asdfasdf",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

num = 99

num.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
  password = "asdfasdf"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

num_s = (num+1).to_s
puts num_s + ' Users created'

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

puts '50 posts created'

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }