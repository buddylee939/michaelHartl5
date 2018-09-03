User.destroy_all

User.create!(name:  "Pep Merc",
             email: "buddylee939@hotmail.com",
             password:              "asdfasdf",
             password_confirmation: "asdfasdf",
             admin: true)

num = 99

num.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
  password = "asdfasdf"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

num_s = (num+1).to_s
puts num_s + ' Users created'