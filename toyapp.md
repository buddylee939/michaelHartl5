<link rel="stylesheet" href="style.css">

# Michael Hartl - Chapter 2 a Toy App
[from here](https://www.railstutorial.org/book)

- rails new toy_app
- in gemfile, move sqlite to dev/test section

```
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end
```

- add production section

```
group :production do
  gem 'pg', '0.20.0'
end
```

- bundle install --without production

## adding users

- rails generate scaffold User name:string email:string
- rails db:migrate
- create a new user
- in routes

```
root 'users#index'

```

- Box 2.2. REpresentational State Transfer (REST)

```
If you read much about Ruby on Rails web development, you’ll see a lot of references to “REST”, which is an acronym for REpresentational State Transfer. REST is an architectural style for developing distributed, networked systems and software applications such as the World Wide Web and web applications. Although REST theory is rather abstract, in the context of Rails applications REST means that most application components (such as users and microposts) are modeled as resources that can be created, read, updated, and deleted—operations that correspond both to the CRUD operations of relational databases and to the four fundamental HTTP request methods: POST, GET, PATCH, and DELETE. (We’ll learn more about HTTP requests in Section 3.3 and especially Box 3.2.)
```

- rails generate scaffold Micropost content:text user_id:integer
- rails db:migrate
- create a few micros and assign user ids
- in micropost.rb add validation

```
  validates :content, length: { maximum: 140 },
                      presence: true
  belongs_to :user
```

- and in user.rb

```
  has_many :microposts
  validates :name, presence: true
  validates :email, presence: true
```

- 

