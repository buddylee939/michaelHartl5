<link rel="stylesheet" href="style.css">

# Michael Hartl - Chapter 3 - 14; creating twitter clone
[from here](https://www.railstutorial.org/book)

- rails new new sample_app
- update the gems

```
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '>= 2.15'
  # gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest-reporters',       '1.1.14'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'  
end

group :production do
  gem 'pg', '0.18.4'
end
```

- bundle install --without production
- git checkout -b static-pages
- rails generate controller StaticPages home help
- **undoing things**

```
(In fact, as we saw in Section 2.2 and Section 2.3, rails generate can make automatic edits to the routes.rb file, which we also want to undo automatically.) In Rails, this can be accomplished with rails destroy followed by the name of the generated element. In particular, these two commands cancel each other out:

  $ rails generate controller StaticPages home help
  $ rails destroy  controller StaticPages home help
Similarly, in Chapter 6 we’ll generate a model as follows:

  $ rails generate model User name:string email:string
This can be undone using

  $ rails destroy model User
(In this case, it turns out we can omit the other command-line arguments. When you get to Chapter 6, see if you can figure out why.)

Another technique related to models involves undoing migrations, which we saw briefly in Chapter 2 and will see much more of starting in Chapter 6. Migrations change the state of the database using the command

  $ rails db:migrate
We can undo a single migration step using

  $ rails db:rollback
To go all the way back to the beginning, we can use

  $ rails db:migrate VERSION=0
As you might guess, substituting any other number for 0 migrates to that version number, where the version numbers come from listing the migrations sequentially.
```

- update the content of /static/home

```
<h1>Sample App</h1>
<p>
  This is the home page for the
  <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
  sample application.
</p>
```

- update content of static/help

```
<h1>Help</h1>
<p>
  Get help on the Ruby on Rails Tutorial at the
  <a href="http://www.railstutorial.org/help">Rails Tutorial help page</a>.
  To get help on this sample app, see the
  <a href="http://www.railstutorial.org/book"><em>Ruby on Rails Tutorial</em>
  book</a>.
</p>
```

## getting started with testing

- test-driven development (TDD),8 a testing technique in which the programmer writes failing tests first, and then writes the application code to get the tests to pass.

```
In this context, it’s helpful to have a set of guidelines on when we should test first (or test at all). Here are some suggestions based on my own experience:

When a test is especially short or simple compared to the application code it tests, lean toward writing the test first.
When the desired behavior isn’t yet crystal clear, lean toward writing the application code first, then write a test to codify the result.
Because security is a top priority, err on the side of writing tests of the security model first.
Whenever a bug is found, write a test to reproduce it and protect against regressions, then write the application code to fix it.
Lean against writing tests for code (such as detailed HTML structure) likely to change in the future.
Write tests before refactoring code, focusing on testing error-prone code that’s especially likely to break.
In practice, the guidelines above mean that we’ll usually write controller and model tests first and integration tests (which test functionality across models, views, and controllers) second. And when we’re writing application code that isn’t particularly brittle or error-prone, or is likely to change (as is often the case with views), we’ll often skip testing altogether.
```

- rails test
- to see red and green, add the 2 lines to the test/test_helper file

```
require "minitest/reporters"
Minitest::Reporters.use!
```

- rails test: we should see the colors

```
“Red, Green, Refactor” cycle
test-driven development involves writing a failing test first, writing the application code needed to get it to pass, and then refactoring the code if necessary. 
```

- in the file test/controllers/static_pages_controller_test add the about test
- ** this is a static page test **

```
  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end
```

- in routes

```
get  'static_pages/about'
```

- rails test: fails; action is missing
- in static_pages controller

```
  def about
  end
```

- rails test: fails; missing templage
- create static_pages/about and add the content

```
<h1>About</h1>
<p>
  The <a href="http://www.railstutorial.org/"><em>Ruby on Rails
  Tutorial</em></a> is a
  <a href="http://www.railstutorial.org/book">book</a> and
  <a href="http://screencasts.railstutorial.org/">screencast series</a>
  to teach web development with
  <a href="http://rubyonrails.org/">Ruby on Rails</a>.
  This is the sample application for the tutorial.
</p>
```

- rails test: passes
- ** adding page titles to each page **
- add the lines to static_pages_cont_test, to each test

```
assert_select "title", "About | Ruby on Rails Tutorial Sample App"
```

- rails test: 3 failures
- update the test code with the 'setup function', which automatically runs before every title test

```
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end  
```

- in the layouts/app file replace the 'title'

```
<title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>
```

- in each of the static pages, respectively, add the code, changing the title based on the page

```
<% provide(:title, "Home") %>
```

- rails test: everything should pass
- ** NOTE ON THE STUFF IN THE HEAD SECTION **

```
It’s also worth noting that the default Rails layout includes several additional lines:

<%= csrf_meta_tags %>
<%= stylesheet_link_tag ... %>
<%= javascript_include_tag "application", ... %>
This code arranges to include the application stylesheet and JavaScript, which are part of the asset pipeline (Section 5.2.1), together with the Rails method csrf_meta_tags, which prevents cross-site request forgery (CSRF), a type of malicious web attack.
```

- ** EXERCISE: Make a Contact page for the sample app.16 Following the model in Listing 3.15, first write a test for the existence of a page at the URL /static_pages/contact by testing for the title “Contact | Ruby on Rails Tutorial Sample App”. Get your test to pass by following the same steps as when making the About page in Section 3.3.3, including filling the Contact page with the content from Listing 3.40.** 
- first make the test to fail

```
  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end    
```

- in routes

```
get  'static_pages/contact'
```

- in static pages controller    

```
  def contact
  end  
```

- create static_pages/contact with the content

```
<% provide(:title, "Contact") %>
<h1>Contact</h1>
<p>
  Contact the Ruby on Rails Tutorial about the sample app at the
  <a href="http://www.railstutorial.org/contact">contact page</a>.
</p>
```

- rails test: should pass
- in routes add root path

```
root 'static_pages#home'
```

- **TEsting the root path**
- in test/cont/stat_pag_cont.test

```
  test "should get root" do
    get root_url
    assert_response :success
  end
```

** 3.6 Advanced testing setup

- using minitest-reporters gem, we did that above,
- in the test/test_helper, add the lines

```
require 'rails/test_help'
require "minitest/reporters"
```

- using guard gem

```
One annoyance associated with using the rails test command is having to switch to the command line and run the tests by hand. To avoid this inconvenience, we can use Guard to automate the running of the tests. Guard monitors changes in the filesystem so that, for example, when we change the static_pages_controller_test.rb file, only those tests get run. Even better, we can configure Guard so that when, say, the home.html.erb file is modified, the static_pages_controller_test.rb automatically runs.
```

- bundle exec guard init
- **He recommends using the guardfile version from his site**
- [from here](https://bitbucket.org/railstutorial/sample_app_4th_ed/raw/289fcb83f1cd72b51c05fe9319277d590d51f0d2/Guardfile)
- copy and paste to the file sample_app/guardfile
- add to .gitignore

```
# Ignore Spring files.
/spring/*.pid
```

-  bundle exec guard
-  [using Guard github](https://github.com/guard/guard)
-  [Guard wiki](https://github.com/guard/guard)

- ** Unix processes - problems with 'Spring' **

```
Box 3.4. Unix processes
On Unix-like systems such as Linux and macOS, user and system tasks each take place within a well-defined container called a process. To see all the processes on your system, you can use the ps command with the aux options:

  $ ps aux
To filter the processes by type, you can run the results of ps through the grep pattern-matcher using a Unix pipe |:

  $ ps aux | grep spring
  ec2-user 12241 0.3 0.5 589960 178416 ? Ssl Sep20 1:46
  spring app | sample_app | started 7 hours ago
The result shown gives some details about the process, but the most important thing is the first number, which is the process id, or pid. To eliminate an unwanted process, use the kill command to issue the Unix termination signal (which happens to be 15) to the pid:

  $ kill -15 12241
This is the technique I recommend for killing individual processes, such as a rogue Rails server (with the pid found via ps aux | grep server), but sometimes it’s convenient to kill all the processes matching a particular process name, such as when you want to kill all the spring processes gunking up your system. In this particular case, you should first try stopping the processes with the spring command itself:

  $ spring stop
Sometimes this doesn’t work, though, and you can kill all the processes with name spring using the pkill command as follows:

  $ pkil
  - l -15 -f spring
Any time something isn’t behaving as expected or a process appears to be frozen, it’s a good idea to run ps aux to see what’s going on, and then run kill -15 <pid> or pkill -15 -f <name> to clear things up.
```

## Chapter 4 - rails flavored Ruby

- git checkout -b rails-flavored-ruby
- ** adding a 'base title', for the pages in case there is no 'title' set
- in the app/helpers/app_helper add

```
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
```

- in layouts/app replace 'title' with

```
<title><%= full_title(yield(:title)) %></title>
```

- update stat_pag_con_test home test with

```
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
```

- rails test: fails 1
- get rid of the 'provide', from the home file
- rails test: pass
= **[For more reference here](https://www.railstutorial.org/book/rails_flavored_ruby)  **

## Chapter 5 - filling in the layout

- update the layouts/app file

```
<!DOCTYPE html>
<html>
  <head>
    <title><%= full_title(yield(:title)) %></title>
    <%= csrf_meta_tags %>
    <%= stylesheet_link_tag    'application', media: 'all',
                                              'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
    <!--[if lt IE 9]>
      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/r29/html5.min.js">
      </script>
    <![endif]-->
  </head>
  <body>
    <header class="navbar navbar-fixed-top navbar-inverse">
      <div class="container">
        <%= link_to "sample app", '#', id: "logo" %>
        <nav>
          <ul class="nav navbar-nav navbar-right">
            <li><%= link_to "Home",   '#' %></li>
            <li><%= link_to "Help",   '#' %></li>
            <li><%= link_to "Log in", '#' %></li>
          </ul>
        </nav>
      </div>
    </header>
    <div class="container">
      <%= yield %>
    </div>
  </body>
</html>
```

- update home page

```
<div class=class="center jumbotron""center jumbotron">
  <h1>Welcome to the Sample AppWelcome to the Sample App</h1>
  <h2>
    This is the home page for the
         This is the home page for the   <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
    sample application.
  </h2>

  <%= link_to "Sign up now!", '#', class: "btn btn-lg btn-primary" %>
</div>

<%= link_to image_tag("rails.png", alt: "Rails logo"),
            'http://rubyonrails.org/' %>
```

- add the bootstrap gem

```
gem 'bootstrap-sass', '3.3.7'
```

- bundle
- create the file custom.scss and add

```
@import "bootstrap-sprockets";
@import "bootstrap";

/* universal */

body {
  padding-top: 60px;
}

section {
  overflow: auto;
}

textarea {
  resize: vertical;
}

.center {
  text-align: center;
}

.center h1 {
  margin-bottom: 10px;
}

/* typography */

h1, h2, h3, h4, h5, h6 {
  line-height: 1;
}

h1 {
  font-size: 3em;
  letter-spacing: -2px;
  margin-bottom: 30px;
  text-align: center;
}

h2 {
  font-size: 1.2em;
  letter-spacing: -1px;
  margin-bottom: 30px;
  text-align: center;
  font-weight: normal;
  color: #777;
}

p {
  font-size: 1.1em;
  line-height: 1.7em;
}

/* header */

#logo {
  float: left;
  margin-right: 10px;
  font-size: 1.7em;
  color: #fff;
  text-transform: uppercase;
  letter-spacing: -1px;
  padding-top: 9px;
  font-weight: bold;
}

#logo:hover {
  color: #fff;
  text-decoration: none;
}
```

- create the layous/shim and layouts/header partials
- and put in layouts/app, in respective places

```
<%= render 'layouts/shim' %>
<%= render 'layouts/header' %>
```

- create the footer partial as well

```
<footer class="footer">
  <small>
    The <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
    by <a href="http://www.michaelhartl.com/">Michael Hartl</a>
  </small>
  <nav>
    <ul>
      <li><%= link_to "About",   '#' %></li>
      <li><%= link_to "Contact", '#' %></li>
      <li><a href="http://news.railstutorial.org/">News</a></li>
    </ul>
  </nav>
</footer>
```

- and add footer render

```            
<%= render 'layouts/footer' %>
```

- add footer css to custom

```
/* footer */

footer {
  margin-top: 45px;
  padding-top: 5px;
  border-top: 1px solid #eaeaea;
  color: #777;
}

footer a {
  color: #555;
}

footer a:hover {
  color: #222;
}

footer small {
  float: left;
}

footer ul {
  float: right;
  list-style: none;
}

footer ul li {
  float: left;
  margin-left: 15px;
}
```

- create the rails_default partial

```
<%= csrf_meta_tags %>
<%= stylesheet_link_tag    'application', media: 'all',
                                          'data-turbolinks-track': 'reload' %>
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>  
```

- and add the render
- 
```
<%= render 'layouts/rails_default' %>
```

- update the custom.scss with sass and mixins

```
@import "bootstrap-sprockets";
@import "bootstrap";

/* mixins, variables, etc. */

$gray-medium-light: #eaeaea;

/* universal */

body {
  padding-top: 60px;
}

section {
  overflow: auto;
}

textarea {
  resize: vertical;
}

.center {
  text-align: center;
  h1 {
    margin-bottom: 10px;
  }
}

/* typography */

h1, h2, h3, h4, h5, h6 {
  line-height: 1;
}

h1 {
  font-size: 3em;
  letter-spacing: -2px;
  margin-bottom: 30px;
  text-align: center;
}

h2 {
  font-size: 1.2em;
  letter-spacing: -1px;
  margin-bottom: 30px;
  text-align: center;
  font-weight: normal;
  color: $gray-light;
}

p {
  font-size: 1.1em;
  line-height: 1.7em;
}


/* header */

#logo {
  float: left;
  margin-right: 10px;
  font-size: 1.7em;
  color: white;
  text-transform: uppercase;
  letter-spacing: -1px;
  padding-top: 9px;
  font-weight: bold;
  &:hover {
    color: white;
    text-decoration: none;
  }
}

/* footer */

footer {
  margin-top: 45px;
  padding-top: 5px;
  border-top: 1px solid $gray-medium-light;
  color: $gray-light;
  a {
    color: $gray;
    &:hover {
      color: $gray-darker;
    }
  }
  small {
    float: left;
  }
  ul {
    float: right;
    list-style: none;
    li {
      float: left;
      margin-left: 15px;
    }
  }
}
```

- **changing the default static pages links **
- update the routes file

```
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
```

- we need to change the tests, 

```
require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get root" do
    get root_path
    assert_response :success
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end  

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end    

end
```

- ** It’s possible to use a named route other than the default using the as: option. Drawing inspiration from this famous Far Side comic strip, change the route for the Help page to use helf (Listing 5.29).**
- in routes you would do

```
get  '/help',    to: 'static_pages#help', as: 'helf'
```

- then the link would be

```
helf_path
```

- update the links in the header file

```
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home",    root_path %></li>
        <li><%= link_to "Help",    help_path %></li>
        <li><%= link_to "Log in", '#' %></li>
      </ul>
    </nav>
  </div>
</header>
```

- update the footer links

```
<li><%= link_to "About",   about_path %></li>
<li><%= link_to "Contact", contact_path %></li>
```

- ** link tests using an integration test **
- rails generate integration_test site_layout and add the code

```
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
```

- to test only this test

```
rails test:integration
```

- **examples of other 'assert_selects'**

```
Code    Matching HTML
assert_select "div" <div>foobar</div>
assert_select "div", "foobar"   <div>foobar</div>
assert_select "div.nav" <div class="nav">foobar</div>
assert_select "div#profile" <div id="profile">foobar</div>
assert_select "div[name=yo]"    <div name="yo">hey</div>
assert_select "a[href=?]", '/', count: 1    <a href="/">foo</a>
assert_select "a[href=?]", '/', text: "foo" <a href="/">foo</a>
```

- ** user signup **
- rails generate controller Users new
- edit the test/cont/user_con test to look for signup_path

```
  test "should get new" do
    get signup_path
    assert_response :success
  end
```

- edit routes to be

```
get 'signup',    to: 'users#new'
```

- add a link test in the site_layout test

```
assert_select "a[href=?]", signup_path
```

- update the signup link in the home page

```
<%= link_to "Sign up now!", signup_path, class: "btn btn-lg btn-primary" %>
```

- add the test in the user_controller

```
  test "should get signup" do
    get signup_path
    assert_response :success
    assert_select "title", "Signup | #{@base_title}"
  end  
```

- update the file users/new

```
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>
<p>This will be a signup page for new users.</p>
```

- move from static_pag_con test, to test_helper

```
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
```

- that way all controllers have access to that

## Chapter 6 - modeling users

- rails generate model User name:string email:string
- rails db:migrate
- ** Most migrations (including all the ones in this tutorial) are reversible, which means we can “migrate down” and undo them with a single command, called db:rollback: **

```
rails db:rollback
```

- rails console --sandbox
- User.new
- user = User.new(name: "Michael Hartl", email: "mhartl@example.com")
- user.valid?
- user.save
- foo = User.create(name: "Foo", email: "foo@bar.com")
- foo.destroy
- ** finding users **
- User.find(1)
- User.find_by(email: "mhartl@example.com")
- User.first
- User.all
- User.find_by_name('Michael Hartl') [legacy apps]
- ** If you’re worried that find_by will be inefficient if there are a large number of users, you’re ahead of the game; we’ll cover this issue, and its solution via database indices, in Section 6.2.5. **
- ** updating user objects **
- user
- user.email = "mhartl@example.net"
- user.save
- user.update_attributes(name: "The Dude", email: "dude@abides.org")
- user.update_attribute(:name, "El Duderino")
- user.update(created_at: 1.year.ago)
- ** user validations **
- Our method will be to start with a valid model object, set one of its attributes to something we want to be invalid, and then test that it in fact is invalid. As a safety net, we’ll first write a test to make sure the initial model object is valid. This way, when the validation tests fail we’ll know it’s for the right reason (and not because the initial object was invalid in the first place).
- update the test/modes/user test

```
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
```

- rails test:models
- ** validating presence **
- update user test

```
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end  
end
```

- rails test should fail, because is not, not valid
- update user.rb

```
 validates :name, presence: true
```

-  rails console --sandbox
-  user = User.new(name: "", email: "mhartl@example.com")
-  user.valid?
-   user.errors.full_messages
-   update the users test for email

```
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end  
```

- add to user.rb

```
validates :email, presence: true
```

- ** length validation **
- update user test

```
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
```

- update the user.rb for length

```
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }
```

- ** format validation **
- Neither the tests nor the validation will be exhaustive, just good enough to accept most valid email addresses and reject most invalid ones. We’ll start with a couple of tests involving collections of valid and invalid addresses. To make these collections, it’s worth knowing about the useful %w[] technique for making arrays of strings, as seen in this console session:
- %w[foo bar baz]
- addresses = %w[USER@foo.COM THE_US-ER@foo.bar.org first.last@foo.jp]
- addresses.each do |address|
- puts address
- end
- update the user test

```
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
```

- add a test for invalid addresses

```
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
```

- ** regex helper **
- [or the website](http://www.rubular.com/)

```
Expression  Meaning
/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    full regex
/   start of regex
\A  match start of a string
[\w+\-.]+   at least one word character, plus, hyphen, or dot
@   literal “at sign”
[a-z\d\-.]+ at least one letter, digit, hyphen, or dot
\.  literal dot
[a-z]+  at least one letter
\z  match end of a string
/   end of regex
i   case-insensitive
```

- update user.rb

```
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
```

- ** uniqueness **
- update user test

```
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase    
    @user.save
    assert_not duplicate_user.valid?
  end
```

- update user.rb

```
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
```

- ** a user can submit twice and mess this uniqueness up**
- If the above sequence seems implausible, believe me, it isn’t: it can happen on any Rails website with significant traffic (which I once learned the hard way). Luckily, the solution is straightforward to implement: we just need to enforce uniqueness at the database level as well as at the model level. Our method is to create a database index on the email column (Box 6.2), and then require that the index be unique.
- ** indexing the email in the database for quick reference **
- rails generate migration add_index_to_users_email
- update the migration file

```
  def change
    add_index :users, :email, unique: true
  end
```

- rails db:migrate
- ** test should fail because fixtures were added that now fail the tests **
- remove the content in test/fixtures/users.yml

```

# one:
#   name: MyString
#   email: MyString

# two:
#   name: MyString
#   email: MyString
```

- ** adding a callback before we save the email address **
- To avoid this incompatibility, we’ll standardize on all lower-case addresses, converting “Foo@ExAMPle.CoM” to “foo@example.com” before saving it to the database. The way to do this is with a callback, which is a method that gets invoked at a particular point in the lifecycle of an Active Record object. In the present case, that point is before the object is saved, so we’ll use a before_save callback to downcase the email attribute before saving the user.17 The result appears in Listing 6.32. (This is just a first implementation; we’ll discuss this subject again in Section 11.1, where we’ll use the preferred method reference convention for defining callbacks.)
- in the user.rb

```
  before_save { email.downcase! }
```

- adding the test to user test

```
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
```

- ** adding the password ability **
- in user.rb

```
has_secure_password
```

- rails generate migration add_password_digest_to_users password_digest:string
- rails db:migrate
- add the bcrypt gem
- bundle
- the tests should be failing because of the password
- update the user test with password attributes

```
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end
```

- the tests should be passing
- in user test add the password tests

```
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
```

- add to the user.rb

```
validates :password, presence: true, length: { minimum: 6 }
```

- rails c, to create an actual user
- User.create(name: "Michael Hartl", email: "mhartl@example.com", password: "foobar", password_confirmation: "foobar")
- u = User.first
- u.password_digest
- u.authenticate("foobaz") to test the authentication
- !!u.authenticate("foobar") 
- ** "Recalling from Section 4.2.3 that !! converts an object to its corresponding boolean value, we can see that user.authenticate does the job nicely:" **

## Chapter 7 - Sign up

- ** This displays some useful information about each page using the built-in debug method and params variable (which we’ll learn more about in Section 7.1.2).**
- in layouts/app add the debug line

```
    <div class="container">
      <%= yield %>
      <%= render 'layouts/footer' %>
      <%= debug(params) if Rails.env.development? %>
    </div>
```

- different rails console environments

```
Box 7.1. Rails environments
Rails comes equipped with three environments: test, development, and production. The default environment for the Rails console is development:

  $ rails console
  Loading development environment
  >> Rails.env
  => "development"
  >> Rails.env.development?
  => true
  >> Rails.env.test?
  => false
As you can see, Rails provides a Rails object with an env attribute and associated environment boolean methods, so that, for example, Rails.env.test? returns true in a test environment and false otherwise.

If you ever need to run a console in a different environment (to debug a test, for example), you can pass the environment as a parameter to the console script:

  $ rails console test
  Loading test environment
  >> Rails.env
  => "test"
  >> Rails.env.test?
  => true
As with the console, development is the default environment for the Rails server, but you can also run it in a different environment:

  $ rails server --environment production
If you view your app running in production, it won’t work without a production database, which we can create by running rails db:migrate in production:

  $ rails db:migrate RAILS_ENV=production
(I find it confusing that the idiomatic commands to run the console, server, and migrate commands in non-default environments use different syntax, which is why I bothered showing all three. It’s worth noting, though, that preceding any of them with RAILS_ENV=<env> will also work, as in RAILS_ENV=production rails server).

By the way, if you have deployed your sample app to Heroku, you can see its environment using heroku run rails console:

  $ heroku run rails console
  >> Rails.env
  => "production"
  >> Rails.env.production?
  => true
Naturally, since Heroku is a platform for production sites, it runs each application in a production environment.
```

- add some css for the debug section

```
@mixin box_sizing {
  -moz-box-sizing:    border-box;
  -webkit-box-sizing: border-box;
  box-sizing:         border-box;
}
/* miscellaneous */

.debug_dump {
  clear: both;
  float: left;
  width: 100%;
  margin-top: 45px;
  @include box_sizing;
}
```

- in routes add user resources

```
resources :users
```

- create the file users/show

```
<%= @user.name %>, <%= @user.email %>
```

- in users controller

```
  def show
    @user = User.find(params[:id])
  end
```

- ** if you haven't restarted server after bcrypt install, restart it **
- go to localhost/users/1 and we should see the first user
- ** using debugger **
- in the users controller update the show action

```
  def show
    @user = User.find(params[:id])
    debugger
  end
```

- in the server terminal, debugger line

```
(byebug) @user.name
"Example User"
(byebug) @user.email
"example@railstutorial.org"
(byebug) params[:id]
"1"
```

- ctrl-D to get out of it, comment out debugger in the show action
- ** adding gravatar for user **
- update the users/show page

```
<% provide(:title, @user.name) %>
<h1>
  <%= gravatar_for @user %>
  <%= @user.name %>
</h1>
```

- in app/helpers/users helper

```
module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
```

- refresh the page
- update the user attribute to see the gravatar he controls
- in rails console

```
$ rails console
>> user = User.first
>> user.update_attributes(name: "Example User",
?>                        email: "example@railstutorial.org",
?>                        password: "foobar",
?>                        password_confirmation: "foobar")
=> true
```

- update the show page with a sidebar

```
<% provide(:title, @user.name) %>
<div class="row">
  <aside class="col-md-4">
    <section class="user_info">
      <h1>
        <%= gravatar_for @user %>
        <%= @user.name %>
      </h1>
    </section>
  </aside>
</div>
```

- update the css to include sidebar and gravatar

```
/* sidebar */

aside {
  section.user_info {
    margin-top: 20px;
  }
  section {
    padding: 10px 0;
    margin-top: 20px;
    &:first-child {
      border: 0;
      padding-top: 0;
    }
    span {
      display: block;
      margin-bottom: 3px;
      line-height: 1;
    }
    h1 {
      font-size: 1.4em;
      text-align: left;
      letter-spacing: -1px;
      margin-bottom: 3px;
      margin-top: 0px;
    }
  }
}

.gravatar {
  float: left;
  margin-right: 10px;
}

.gravatar_edit {
  margin-top: 15px;
}
```

- ** Sign up form **
- in users controller, update the new action

```
  def new
    @user = User.new
  end
```

- add the code to users/new

```
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= f.label :name %>
      <%= f.text_field :name %>

      <%= f.label :email %>
      <%= f.email_field :email %>

      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation %>

      <%= f.submit "Create my account", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>
```

- and the css for the form

```
/* forms */

input, textarea, select, .uneditable-input {
  border: 1px solid #bbb;
  width: 100%;
  margin-bottom: 15px;
  @include box_sizing;
}

input {
  height: auto !important;
}
```

- ** unsuccessful signups **
- update the new form to include error messages

```
<% provide(:title, 'Sign up') %>
<h1>Sign up</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user) do |f| %>
      <%= render 'shared/error_messages' %>

      <%= f.label :name %>
      <%= f.text_field :name, class: 'form-control' %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Create my account", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>
```

- create views/shared/error_messages partial

```
<% if @user.errors.any? %>
  <div id="error_explanation">
    <div class="alert alert-danger">
      The form contains <%= pluralize(@user.errors.count, "error") %>.
    </div>
    <ul>
    <% @user.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
<% end %>
```

- add error css to custom.scss

```
#error_explanation {
  color: red;
  ul {
    color: red;
    margin: 0 0 30px 0;
  }
}

.field_with_errors {
  @extend .has-error;
  .form-control {
    color: $state-danger-text;
  }
}
```

- in users controller, add create and private actions

```
  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
```

- ** test for invalid form submissions ** 
- rails generate integration_test users_signup

```
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'       
  end
```

- test should be green, because we wrote the code before
- update routes

```
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
```

- update the new form with url on the form for

```
<%= form_for(@user, url: signup_path) do |f| %>
```

- update the user signup test with the sign up path

```
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
```

- update user signup test with presence of [form]     

```
assert_select 'form[action="/signup"]'   
```

- that is looking for form in signup, so new form should have

```
<%= form_for(@user, url: signup_path) do |f| %>
```

- tests should be green
- ** successful signups **
- add the redirect to users create action

```
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"    
      redirect_to @user
    else
      render 'new'
    end
  end
```

- add the flash output to the layout/app above yield

```
      <% flash.each do |message_type, message| %>
        <%= content_tag(:div, message, class: "alert alert-#{message_type}") %>
      <% end %>
```

- clear out the database

```
rails db:migrate:reset
```

- refresh and create a new user at localhost/signup
- ** valid test for submission **
- add the signup info test to integration/users_signup

```
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert.alert-success'  
    assert_not flash.empty?
  end
```

# 7.5 professional grade deployment

- merge any last changes and push
- 
```
$ git add -A
$ git commit -m "Finish user signup"
$ git checkout master
$ git merge sign-up
```

- in config/env/production.rb uncomment

```
config.force_ssl = true
```

- **At this stage, we need to set up SSL on the remote server. Setting up a production site to use SSL involves purchasing and configuring an SSL certificate for your domain. That’s a lot of work, though, and luckily we won’t need it here: for an application running on a Heroku domain (such as the sample application), we can piggyback on Heroku’s SSL certificate. As a result, when we deploy the application in Section 7.5.2, SSL will automatically be enabled. (If you want to run SSL on a custom domain, such as www.example.com, refer to Heroku’s documentation on SSL.)**
- [heres the documentation](http://devcenter.heroku.com/articles/ssl)
- **Having added SSL, we now need to configure our application to use a webserver suitable for production applications. By default, Heroku uses a pure-Ruby webserver called WEBrick, which is easy to set up and run but isn’t good at handling significant traffic. As a result, WEBrick isn’t suitable for production use, so we’ll replace WEBrick with Puma, an HTTP server that is capable of handling a large number of incoming requests.

To add the new webserver, we simply follow the Heroku Puma documentation. The first step is to include the puma gem in our Gemfile, but as of Rails 5 Puma is included by default (Listing 3.2). This means we can skip right to the second step, which is to replace the default contents of the file config/puma.rb with the configuration shown in Listing 7.37. The code in Listing 7.37 comes straight from the Heroku documentation,13 and there is no need to understand it (Box 1.1).**

- replace the content in config/puma with

```
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
```

- at the root of the app create the file Procfile (./Procfile)

```
web: bundle exec puma -C config/puma.rb
```

- save and commit changes

```
$ rails test
$ git add -A
$ git commit -m "Use SSL and the Puma webserver in production"
$ git push
$ git push heroku
$ heroku run rails db:migrate
```

- ** RUBY VERSION NUMBER IN PRODUCTION **

- When deploying to Heroku, you may get a warning message like this one:

```
###### WARNING:
       You have not declared a Ruby version in your Gemfile.
       To set your Ruby version add this line to your Gemfile:
       ruby '2.1.5'
```

```
Experience shows that, at the level of this tutorial, the costs associated with including such an explicit Ruby version number outweigh the (negligible) benefits, so you should ignore this warning for now. The main issue is that keeping your sample app and system in sync with the latest Ruby version can be a huge inconvenience,15 and yet it almost never makes a difference which exact Ruby version number you use. Nevertheless, you should bear in mind that, should you ever end up running a mission-critical app on Heroku, specifying an exact Ruby version in the Gemfile is recommended to ensure maximum compatibility between development and production environments.
```

## Chapter 8 - Basic login

- rails generate controller Sessions new
- add in the routes

```
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
```

- update the code in test/cont/sessions_cont

```
  test "should get new" do
    get login_path
    assert_response :success
  end
```

- tests should be green
- update sessions/new

```
<% provide(:title, "Log in") %>
<h1>Log in</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:session, url: login_path) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.submit "Log in", class: "btn btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
  </div>
</div>
```

- update the sessions controller

```
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
  end
```

-  **a flash test - testing for login submission **
-  add the code to test/inte/users login test

```
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
```

- ** to run only 1 test, not all of them, nor the ones in a folder **

```
rails test test/integration/users_login_test.rb
```

- in sessions controller, replace flash with flash.now

```
      flash.now[:danger] = 'Invalid email/password combination'
```

- ** logging in **
- in app controller add

```
include SessionsHelper
```

- in helpers/sessions helper

```
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
```

- Because temporary cookies created using the session method are automatically encrypted, the code in Listing 8.14 is secure, and there is no way for an attacker to use the session information to log in as the user. This applies only to temporary sessions initiated with the session method, though, and is not the case for persistent sessions created using the cookies method. Permanent cookies are vulnerable to a session hijacking attack, so in Chapter 9 we’ll have to be much more careful about the information we place on the user’s browser.
- in sessions controller, update the create action

```
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
```

- add to the helpers/session helper

```
  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
```

- ** heres an example of this in the console **

```
>> session = {}
>> session[:user_id] = nil
>> @current_user ||= User.find_by(id: session[:user_id])
<What happens here?>
>> session[:user_id]= User.first.id
>> @current_user ||= User.find_by(id: session[:user_id])
<What happens here?>
>> @current_user ||= User.find_by(id: session[:user_id])
<What happens here?>
```

- ** layout links changed **
- add to the helpers/sessions helper

```
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
```

- update the header partial with all the user links

```
<header class="navbar navbar-fixed-top navbar-inverse">
  <div class="container">
    <%= link_to "sample app", root_path, id: "logo" %>
    <nav>
      <ul class="nav navbar-nav navbar-right">
        <li><%= link_to "Home", root_path %></li>
        <li><%= link_to "Help", help_path %></li>
        <% if logged_in? %>
          <li><%= link_to "Users", '#' %></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              Account <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
              <li><%= link_to "Profile", current_user %></li>
              <li><%= link_to "Settings", '#' %></li>
              <li class="divider"></li>
              <li>
                <%= link_to "Log out", logout_path, method: :delete %>
              </li>
            </ul>
          </li>
        <% else %>
          <li><%= link_to "Log in", login_path %></li>
        <% end %>
      </ul>
    </nav>
  </div>
</header>
```

- dropdown doesnt work cuz we havent add the js
- in app.js

```
//= require jquery
//= require bootstrap
```

- add the jquery-rails gem
- refresh and test out the dropdown and login
- ** testing layout changes using fixtures **
- In order to see these changes, our test needs to log in as a previously registered user, which means that such a user must already exist in the database. The default Rails way to do this is to use fixtures, which are a way of organizing data to be loaded into the test database. We discovered in Section 6.2.5 that we needed to delete the default fixtures so that our email uniqueness tests would pass (Listing 6.31). Now we’re ready to start filling in that empty file with custom fixtures of our own.
- add the code to user.rb

```
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
```

-   in test/fixtures/users.yml

```
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>
```

- update the users login test with

```
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end  
end
```

- rails test test/integration/users_login_test.rb
- should be green
- ** login upon signup **
- update users controller, add a log in user

```
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
```

-   add to test/test helper

```
  def is_logged_in?
    !session[:user_id].nil?
  end
```

- add to inte/users signup test

```
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
```

- test should be green
- ** logging out **
- add to helpers/sessions helper

```
  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
```

- update destroy action in cont/sess controller

```
  def destroy
    log_out
    redirect_to root_url
  end
```

- update inte/users login test, so it logs in and logs out

```
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
```

- rails test should be green
- refresh page and test login and logout

## Chapter 9 - advanced login

- ** remember me**

```
As noted in Section 8.2.1, information stored using session is automatically secure, but this is not the case with information stored using cookies. In particular, persistent cookies are vulnerable to session hijacking, in which an attacker uses a stolen remember token to log in as a particular user. There are four main ways to steal cookies: (1) using a packet sniffer to detect cookies being passed over insecure networks,1 (2) compromising a database containing remember tokens, (3) using cross-site scripting (XSS), and (4) gaining physical access to a machine with a logged-in user. We prevented the first problem in Section 7.5 by using Secure Sockets Layer (SSL) site-wide, which protects network data from packet sniffers. We’ll prevent the second problem by storing a hash digest of the remember tokens instead of the token itself, in much the same way that we stored password digests instead of raw passwords in Section 6.3.2 Rails automatically prevents the third problem by escaping any content inserted into view templates. Finally, although there’s no iron-clad way to stop attackers who have physical access to a logged-in computer, we’ll minimize the fourth problem by changing tokens every time a user logs out and by taking care to cryptographically sign any potentially sensitive information we place on the browser.
```

- With these design and security considerations in mind, our plan for creating persistent sessions appears as follows:

```
Create a random string of digits for use as a remember token.
Place the token in the browser cookies with an expiration date far in the future.
Save the hash digest of the token to the database.
Place an encrypted version of the user’s id in the browser cookies.
When presented with a cookie containing a persistent user id, find the user in the database using the given id, and verify that the remember token cookie matches the associated hash digest from the database.
```

- rails generate migration add_remember_digest_to_users remember_digest:string
- rails db:migrate
- ** using base64 random **

```
$ rails console
>> SecureRandom.urlsafe_base64
=> "q5lt38hQDc_959PVoo6b7A"
```

- add to the bottom of user.rb

```
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
```

- update user.rb with remember and attr_accessor

```
class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end
```

- add to user.rb authenticated method

```
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
```

- update the create in sessions controller

```
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      remember user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
```

- update the helpers/sessions helper with a remember method

```
module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end  

  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end   

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end   
end
```

- update the current user in sessions helper with

```
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
```

- test should be red, cuz users can't log out

## forgetting users

- in user.rb add the forget method

```
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
```

- in helpers/sessions helper add forget 

```
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
```

- ** problems with the cookies when on chrome and firefox at the same time and you log out out of one or close the other, the one left open will have problems logging out, so we have to **
- write a test for this, in inte/users login test update the code to be

```
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
```

- update destroy action in sessions controller

```
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
```

- in test/models/user test add authenticated?

```
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
```

- ** remember me check box
- add the checkbox to the form
- add the css

```
.checkbox {
  margin-top: -10px;
  margin-bottom: 10px;
  span {
    margin-left: 20px;
    font-weight: normal;
  }
}

#session_remember_me {
  width: auto;
  margin-left: 0;
}
```

- update the create action in the sessions controller

```
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
```

- refresh and test out the remember me
- ** remember tests **
- update test/test helper

```
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest

  # Log in as a particular user.
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
```

- update int users login test

```
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
```

- test should be green
- update create action in sessions controller

```
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
```

- and add to inte/users login test

```
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # assert_equal cookies['remember_token'], assigns(:user).remember_token
    assert_equal assigns[:user].remember_token, cookies['remember_token']
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@user, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
```

- ** testing the remember branch **
- in helpers/sessions helper add the raise line to the current user action

```
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
     raise       # The tests still pass, so this branch is currently untested.      
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
```

- create the file at the terminal

```
touch test/helpers/sessions_helper_test.rb
```

- add the code to helpers/sessions helper

```
require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
```

- in helpers/sessions helper replace the current user method

```
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
```

- tests should be green

### uploading current state to heroku

- Before deploying to Heroku, it’s worth noting that the application will briefly be in an invalid state after pushing but before the migration is finished. On a production site with significant traffic, it’s a good idea to turn maintenance mode on before making the changes:
[for more on this read here](https://devcenter.heroku.com/articles/maintenance-mode)

```
If you need to temporarily disable access to your Heroku app (for example, to perform a large migration), you can enable Heroku’s built-in maintenance mode. While in maintenance mode, your app serves a static maintenance page to all visitors.
```

```
$ heroku maintenance:on
$ git push heroku
$ heroku run rails db:migrate
$ heroku maintenance:off
```

## Chapter 10 - updating, showing, and deleting users

- ** updating users **
- 