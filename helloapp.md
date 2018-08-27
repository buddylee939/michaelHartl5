<link rel="stylesheet" href="style.css">

# Michael Hartl - Chapter 1 from zero to deploy 
[from here](https://www.railstutorial.org/book)

- Other sources to learn rails

```
The Learn Enough Society: Premium subscription service that includes a special enhanced version of the Ruby on Rails Tutorial book and 15+ hours of streaming screencast lessons filled with the kind of tips, tricks, and live demos that you can’t get from reading a book. Also includes text and videos for the other Learn Enough tutorials. Scholarship discounts are available.
Code School: Good interactive online programming courses
The Turing School of Software & Design: A full-time, 27-week training program in Denver, Colorado
Bloc: An online bootcamp with a structured curriculum, personalized mentorship, and a focus on learning through concrete projects. Use the coupon code BLOCLOVESHARTL to get $500 off the enrollment fee.
Launch School: A good online Rails development bootcamp (includes advanced material)
Firehose Project: A mentor-driven, online coding bootcamp focused on real-world programming skills like test-driven development, algorithms, and building an advanced web application as part of an agile team. Two-week free intro course.
Thinkful: An online class that pairs you with a professional engineer as you work through a project-based curriculum
Pragmatic Studio: Online Ruby and Rails courses from Mike and Nicole Clark. Along with Programming Ruby author Dave Thomas, Mike taught the first Rails course I took, way back in 2006.
RailsApps: A large variety of detailed topic-specific Rails projects and tutorials
Rails Guides: Topical and up-to-date Rails references
```

- rails new hello_app
- what each folder is

```
File/Directory  Purpose
app/    Core application (app) code, including models, views, controllers, and helpers
app/assets  Applications assets such as cascading style sheets (CSS), JavaScript files, and images
bin/    Binary executable files
config/ Application configuration
db/ Database files
doc/    Documentation for the application
lib/    Library modules
lib/assets  Library assets such as cascading style sheets (CSS), JavaScript files, and images
log/    Application log files
public/ Data accessible to the public (e.g., via web browsers), such as error pages
bin/rails   A program for generating code, opening console sessions, or starting a local server
test/   Application tests
tmp/    Temporary files
vendor/ Third-party code such as plugins and gems
vendor/assets   Third-party assets such as cascading style sheets (CSS), JavaScript files, and images
README.md   A brief description of the application
Rakefile    Utility tasks available via the rake command
Gemfile Gem requirements for this app
Gemfile.lock    A list of gems used to ensure that all copies of the app use the same gem versions
config.ru   A configuration file for Rack middleware
.gitignore  Patterns for files that should be ignored by Git
Table 1.2: A summary of the default Rails directory structure.
```

- in gemfile, move sqlite to dev/test section

```
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end
```

- bundle
- rails s
- in app_controller add the action

```
  def hello
    render html: 'hello, world'
  end
```

- in routes.

```
root 'application#hello
```

- rails s and go to localhost, we should see the hello world

## deploy with heroku

- in the gemfile

```
group :production do
  gem 'pg', '0.20.0'
end
```

- bundle install --without production
- git commit and push
- heroku --version
- heroku login
- heroku keys:add
- heroku create
- git push heroku master
- heroku rename rails-tutorial-hello
- heroku help 

# the end
