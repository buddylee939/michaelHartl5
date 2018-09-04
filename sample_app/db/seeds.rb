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