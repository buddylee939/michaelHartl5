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
- in users controller, add edit action

```
  def edit
    @user = User.find(params[:id])
  end
```

- create users/edit file

```
<% provide(:title, "Edit user") %>
<h1>Update your profile</h1>

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

      <%= f.submit "Save changes", class: "btn btn-primary" %>
    <% end %>

    <div class="gravatar_edit">
      <%= gravatar_for @user %>
      <a href="http://gravatar.com/emails" target="_blank" rel="noopener noreferrer">change</a>
    </div>
  </div>
</div>
```

- add the edit link to header partial

```
<ul class="dropdown-menu">
  <li><%= link_to "Profile", current_user %></li>
  <li><%= link_to "Settings", edit_user_path(current_user) %></li>
  <li class="divider"></li>
  <li>
    <%= link_to "Log out", logout_path, method: :delete %>
  </li>
</ul>
```

- ** using target blank on links bad practice **

```
As noted above, there’s a minor security issue associated with using target="_blank" to open URLs, which is that the target site gains control of what’s known as the “window object” associated with the HTML document. The result is that the target site could potentially introduce malicious content, such as a phishing page. This is extremely unlikely to happen when linking to a reputable site like Gravatar, but it turns out that we can eliminate the risk entirely by setting the rel attribute (“relationship”) to "noopener" in the origin link. Add this attribute to the Gravatar edit link in Listing 10.2.
```

- create the users/form partial

```
<%= form_for(@user, url: yield(:path)) do |f| %>
  <%= render 'shared/error_messages', object: @user %>

  <%= f.label :name %>
  <%= f.text_field :name, class: 'form-control' %>

  <%= f.label :email %>
  <%= f.email_field :email, class: 'form-control' %>

  <%= f.label :password %>
  <%= f.password_field :password, class: 'form-control' %>

  <%= f.label :password_confirmation %>
  <%= f.password_field :password_confirmation, class: 'form-control' %>

  <%= f.submit yield(:button_text), class: "btn btn-primary" %>
<% end %>
```

- update users/new, we have to pass the url to the partial for the signup_path

```
<% provide(:title, 'Sign up') %>
<% provide(:button_text, 'Create my account') %>
<% provide(:path, signup_path) %>
<h1>Sign up</h1>
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= render 'form' %>
  </div>
</div>

```

- update edit

```
<% provide(:title, 'Edit user') %>
<% provide(:button_text, 'Save changes') %>
<% provide(:path, user_path) %>
<h1>Update your profile</h1>
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= render 'form' %>
    <div class="gravatar_edit">
      <%= gravatar_for @user %>
      <a href="http://gravatar.com/emails" target="_blank">Change</a>
    </div>
  </div>
</div>
```

- update the create and update users controller

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
    else
      render 'edit'
    end
  end
```

- ** testing unsuccessful edits **
- rails generate integration_test users_edit
- in inte/users edit test

```
require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end
end
```

- test is green
- ** successful edits **
- add to the inte/users edit test

```
  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
```

- update the update action in users controller

```
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
```

- in user.rb update the password validation to allow nil

```
validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
```

- tests should be green
- ** AUTHORIZATION **
- in users controller, add the before action and method

```
 before_action :logged_in_user, only: [:edit, :update]
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end 
```

- in inte/users edit test, update the 2 tests

```
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end  
```

- update the test/contr/users controller test

```
require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    # because this is doing a def setup, it is changing the title from test_helper
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should get signup" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end  

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
```

- tests should be green
- ** requiring the right user **
- add a second user to fixtures/users.yml

```
archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>
```

- add second user and test in test/contr/users controller test

```
require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    # because this is doing a def setup, it is changing the title from test_helper
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should get signup" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end  

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end  

end
```

- in users controllers add a second before action and method

```
before_action :correct_user,   only: [:edit, :update]
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
```

- tests should be green
- in helpers/sessions helper add a current_user? method

```
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
```

- update the correct user in users controller

```
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
```

- ** friendly forwarding**
- in test/inte/users edit test, update the successful edit

```
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
```

- in helpers/sessions helper add the methods

```
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
```

- update logged in user in users controller

```
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
```

-  in sessions controller, update the create action

```
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
```

- tests should be green
- ** Showing all users **
- in test/contro/users controller test add the index test, under def setup

```
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
```

- in users controllers add index action and to the before action

```
before_action :logged_in_user, only: [:index, :edit, :update]
  def index
    @users = User.all
  end
```

- create the users/index page

```
<% provide(:title, 'All users') %>
<h1>All users</h1>

<ul class="users">
  <% @users.each do |user| %>
    <li>
      <%= gravatar_for user, size: 50 %>
      <%= link_to user.name, user %>
    </li>
  <% end %>
</ul>
```

- add the css

```
/* Users index */

.users {
  list-style: none;
  margin: 0;
  li {
    overflow: auto;
    padding: 10px 0;
    border-bottom: 1px solid $gray-lighter;
  }
}
```

- add the link to the header

```
    <li><%= link_to "Users", users_path %></li>
```

- all tests should be green
- refresh and test out the page
- ** creating sample users **
- add the Faker gem
- in the seeds file add

```
User.destroy_all

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
```
- then in terminal

```
$ rails db:migrate:reset
$ rails db:seed
```

- ** pagination **
- add will paginate and bootstrap will paginate gems

```
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'bootstrap-will_paginate', '~> 1.0'
```

- bundle
- restart server
- update the users index

```
<% provide(:title, 'All users') %>
<h1>All users</h1>

<%= will_paginate %>

<ul class="users">
  <% @users.each do |user| %>
    <li>
      <%= gravatar_for user, size: 50 %>
      <%= link_to user.name, user %>
    </li>
  <% end %>
</ul>

<%= will_paginate %>
```

- update the index action in users controllers

```
  def index
    @users = User.paginate(page: params[:page])
  end
```

- ** users index test **
- in test/fixtures/users.yml create 30 users

```
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>

archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>

lana:
  name: Lana Kane
  email: hands@example.gov
  password_digest: <%= User.digest('password') %>

malory:
  name: Malory Archer
  email: boss@example.gov
  password_digest: <%= User.digest('password') %>

<% 30.times do |n| %>
user_<%= n %>:
  name:  <%= "User #{n}" %>
  email: <%= "user-#{n}@example.com" %>
  password_digest: <%= User.digest('password') %>
<% end %>
```

- rails generate integration_test users_index
- in test/inte/users index test

```
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
```

- test should be green
- create the partial users/user.html.erb

```
<li>
  <%= gravatar_for user, size: 50 %>
  <%= link_to user.name, user %>
</li>
```

- replace the li in the users/index

```
<ul class="users">
  <% @users.each do |user| %>
    <%= render user %>
  <% end %>
</ul>
```

- tests should be green
- ** deleting users **
- creating admin users
- rails generate migration add_admin_to_users admin:boolean
- update the code in the migration file

```
  def change
    add_column :users, :admin, :boolean, default: false
  end
```

- rails db:migrate
- update the seed file

```
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)
```

- rails db:migrate:reset
- rails db:seed
- ** Because we didn't include :admin in the private params hash in the users controller we should be ok against malicious attacks **

```
Revisiting strong parameters
You might have noticed that Listing 10.55 makes the user an admin by including admin: true in the initialization hash. This underscores the danger of exposing our objects to the wild Web: if we simply passed an initialization hash in from an arbitrary web request, a malicious user could send a PATCH request as follows:13

patch /users/17?admin=1
This request would make user 17 an admin, which would be a potentially serious security breach.

Because of this danger, it is essential that we only update attributes that are safe to edit through the web. As noted in Section 7.3.2, this is accomplished using strong parameters by calling require and permit on the params hash:

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
Note in particular that admin is not in the list of permitted attributes. This is what prevents arbitrary users from granting themselves administrative access to our application. Because of its importance, it’s a good idea to write a test for any attribute that isn’t editable, and writing such a test for the admin attribute is left as an exercise (Section 10.4.1.2).
```

- in users controller test, add the test

```
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
```

- add :admin to params in users controller, the test should go red
- take out :admin
- ** destroy action **
- in users/user partial

```
<li>
  <%= gravatar_for user, size: 50 %>
  <%= link_to user.name, user %>
  <% if current_user.admin? && !current_user?(user) %>
    | <%= link_to "delete", user, method: :delete,
                                  data: { confirm: "You sure?" } %>
  <% end %>
</li>
```

- add the destroy action to users controller

```
before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
```

- in users controller, add a destroy filter

```
before_action :admin_user,     only: :destroy
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
```

- ** user destroy tests **
- update 'michael' in test/fixtures/users.yml to be admin

```
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>
  admin: true
```

- in test/contr/users contro test

```
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end  
```

- in inte/users index test

```
require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user     = users(:michael)
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end  
end
```

- all tests should be green
- ** to update on heroku with seeds **

```
$ rails test
$ git push heroku
$ heroku pg:reset DATABASE
$ heroku run rails db:migrate
$ heroku run rails db:seed
$ heroku restart
```

## Chapter 11 - account activation

- here is the plan

```
Our strategy for handling account activation parallels user login (Section 8.2) and especially remembering users (Section 9.1). The basic sequence appears as follows:2

Start users in an “unactivated” state.
When a user signs up, generate an activation token and corresponding activation digest.
Save the activation digest to the database, and then send an email to the user with a link containing the activation token and user’s email address.3
When the user clicks the link, find the user by email address, and then authenticate the token by comparing with the activation digest.
If the user is authenticated, change the status from “unactivated” to “activated”.
```

- rails generate controller AccountActivations
- in routes

```
resources :account_activations, only: [:edit]
```

- in terminal

```
$ rails generate migration add_activation_to_users \
> activation_digest:string activated:boolean activated_at:datetime
```

- update the migrated file

```
class AddActivationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end
```

- rails db:migrate
- add to the user.rb

```
class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end    

  private

    # Converts email to all lower-case.
    def downcase_email
      # self.email = email.downcase
      email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
```

- update the seed files as well

```
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
```

- and test/fixtures/user.yml

```
michael:
  name: Michael Example
  email: michael@example.com
  password_digest: <%= User.digest('password') %>
  admin: true
  activated: true
  activated_at: <%= Time.zone.now %>

archer:
  name: Sterling Archer
  email: duchess@example.gov
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>

lana:
  name: Lana Kane
  email: hands@example.gov
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>

malory:
  name: Malory Archer
  email: boss@example.gov
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>

<% 30.times do |n| %>
user_<%= n %>:
  name:  <%= "User #{n}" %>
  email: <%= "user-#{n}@example.com" %>
  password_digest: <%= User.digest('password') %>
  activated: true
  activated_at: <%= Time.zone.now %>
<% end %>
```

- in terminal

```
$ rails db:migrate:reset
$ rails db:seed
```

## ** account activation emails **
- rails generate mailer UserMailer account_activation password_reset
- in the file views/user_mailer/account_activation.text.erb

```
UserMailer#account_activation

<%= @greeting %>, find me in app/views/user_mailer/account_activation.text.erb
```

- in views/user_mailer/account_activation_html

```
<h1>UserMailer#account_activation</h1>

<p>
  <%= @greeting %>, find me in app/views/user_mailer/account_activation.html.erb
</p>
```

- in mailers/user_mailer

```
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
```

- in mailers/user_mailer

```
class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
```

- ** now we need to update the code **
- update mailers/application_mailer

```
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout 'mailer'
end
```

- mailing account activation link: in mailers/user_mailer

```
class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
```

- update views/user_mailer/account_activation.text

```
Hi <%= @user.name %>,

Welcome to the Sample App! Click on the link below to activate your account:

<%= edit_account_activation_url(@user.activation_token, email: @user.email) %>
```

- in views/user_mailer/account_activation.html

```
<h1>Sample App</h1>

<p>Hi <%= @user.name %>,</p>

<p>
Welcome to the Sample App! Click on the link below to activate your account:
</p>

<%= link_to "Activate", edit_account_activation_url(@user.activation_token,
                                                    email: @user.email) %>
```

- ** email previews **

```
11.2.2 Email previews
To see the results of the templates defined in Listing 11.13 and Listing 11.14, we can use email previews, which are special URLs exposed by Rails to let us see what our email messages look like. First, we need to add some configuration to our application’s development environment, as shown in Listing 11.16.
```

- in config/env/dev

```
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :test
  host = 'localhost:3000'                     # Local server
  config.action_mailer.default_url_options = { host: host, protocol: 'http' }
```

- rails server
- update the file: test/mailers/previews/user_mailer_preview

```
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end
end
```

- **email tests**
- in test/mailers/user_mailer_test

```
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
```

- in config/env/test update the host

```
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { host: 'example.com' }
```

- tests should be green
- udating the users create action
- update the create action in users controller

```
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
```

- currently test are red because of redirect to root and not profile, 
- in test/inte/users signup test, comment out

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
    # assert_template 'users/show'
    # assert_not flash.empty?
    # assert is_logged_in?
  end
```

- refresh and try signing up as a new user. we should get redirected and the email should appear in the rails server logs
- in rails c, we can see last user is not activated, although currently they can log in
- ** activating the account **

```
The solution involves our first example of metaprogramming, which is essentially a program that writes a program. (Metaprogramming is one of Ruby’s strongest suits, and many of the “magic” features of Rails are due to its use of Ruby metaprogramming.) The key in this case is the powerful send method, which lets us call a method with a name of our choice by “sending a message” to a given object. For example, in this console session we use send on a native Ruby object to find the length of an array:
```

- replace in user.rb

```
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
```

- in helpers/sessions_helper replace current_user

```
  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
```

- in test/models/user_test.rb

```
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
```

- tests should be green
- in contr/account activations controller

```
class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
```

- go to the link from the rails server log to activate
- at the moment, once user signs up, they can log in because the activation doesn't deterr it
- to fix that
- up date the create action in sessions controller

```
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
```

- update test/inte/users_signup_test

```
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
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
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end

```

- all tests should be green (im having probelems with one)
- add to the user.rb

```
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
```

- update create action in users controller

```
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
```

- update contr/acount activations controller

```
class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
```

- all tests should be green
- in users controller, update the index action and show

```
  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where(activated: true)
                  .paginate(page: params[:page])
                  .order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    # debugger
  end
```

- the index shows only activated users in the index and the show, if you type localhost/users/(non-activated user id) it should redirect to root path

### email in production - using sendgrid

```
To send email in production, we’ll use SendGrid, which is available as an add-on at Heroku for verified accounts. (This requires adding credit card information to your Heroku account, but there is no charge when verifying an account.) For our purposes, the “starter” tier (which as of this writing is limited to 400 emails a day but costs nothing) is the best fit. We can add it to our app as follows:
```

- in terminal
- heroku addons:create sendgrid:starter

```
(This might fail on systems with an older version of Heroku’s command-line interface. In this case, either upgrade to the latest Heroku toolbelt or try the older syntax heroku addons:add sendgrid:starter.)

To configure our application to use SendGrid, we need to fill out the SMTP settings for our production environment. As shown in Listing 11.41, you will also have to define a host variable with the address of your production website.
```

- in config/env/prod

```
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  host = '<your heroku app>.herokuapp.com'
  config.action_mailer.default_url_options = { host: host }
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
```

```
The email configuration in Listing 11.41 includes the user_name and password of the SendGrid account, but note that they are accessed via the ENV environment variable instead of being hard-coded. This is a best practice for production applications, which for security reasons should never expose sensitive information such as raw passwords in source code. In the present case, these variables are configured automatically via the SendGrid add-on, but we’ll see an example in Section 13.4.4 where we’ll have to define them ourselves. In case you’re curious, you can view the environment variables used in Listing 11.41 as follows:
```

- in terminal

```
$ heroku config:get SENDGRID_USERNAME
$ heroku config:get SENDGRID_PASSWORD
```

- then git commit and push

```
$ rails test
$ git push
$ git push heroku
$ heroku run rails db:migrate
```

- go to heroku site and try signing up with address you own and we should get an email activation

## Chapter 12 - password reset

- rails generate controller PasswordResets new edit --no-test-framework
- in routes

```
resources :password_resets,     only: [:new, :create, :edit, :update]
```

- in views/sessions/new

```
      <%= f.label :password %>
      <%= link_to "(forgot password)", new_password_reset_path %>
      <%= f.password_field :password, class: 'form-control' %>
```

- in terminal

```
$ rails generate migration add_reset_to_users reset_digest:string \
> reset_sent_at:datetime
```

- rails db:migrate
- add the code to file views/password resets/new

```
<% provide(:title, "Forgot password") %>
<h1>Forgot password</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(:password_reset, url: password_resets_path) do |f| %>
      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.submit "Submit", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>
```

- update the code in contr/password resets contr

```
class PasswordResetsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
end
```

- in user.rb

```
    attr_accessor :remember_token, :activation_token, :reset_token
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
```

- password reset emails
- in mailers/user mailer, update the password reset

```
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
```

- update views/user mailer/password reset text

```
To reset your password click the link below:

<%= edit_password_reset_url(@user.reset_token, email: @user.email) %>

This link will expire in two hours.

If you did not request your password to be reset, please ignore this email and
your password will stay as it is.
```

- update views user mailer password reset html

```
<h1>Password reset</h1>

<p>To reset your password click the link below:</p>

<%= link_to "Reset password", edit_password_reset_url(@user.reset_token,
                                                      email: @user.email) %>

<p>This link will expire in two hours.</p>

<p>
If you did not request your password to be reset, please ignore this email and
your password will stay as it is.
</p>
```

- update test/mailers/previews/user mailer preview

```
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end
end
```

- preview the html and text links
- ** email tests **
- in test/mailers/user mailer test add password reset, heres all the test in there

```
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
```

- tests should be green (if I comment some of the lines, the tests are still green, ,I feel that the mail is being created but we are not going to that page)
- ** resetting the password **
- in views/password resets/edit add the code

```
<% provide(:title, 'Reset password') %>
<h1>Reset password</h1>

<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <%= form_for(@user, url: password_reset_path(params[:id])) do |f| %>
      <%= render 'shared/error_messages' %>

      <%= hidden_field_tag :email, @user.email %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field :password_confirmation, class: 'form-control' %>

      <%= f.submit "Update password", class: "btn btn-primary" %>
    <% end %>
  </div>
</div>
```

- in the controllers/password resets controller

```
class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end  
end
```

- refresh and test out with an activated user account
- ** updating the reset **

```
An expired password reset
A failed update due to an invalid password
A failed update (which initially looks “successful”) due to an empty password and confirmation
A successful update
```

- in cont/password resets controller

```
class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # Case (1)

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end  

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end  

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end 

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end     
end
```

- in user.rb, before the private section

```
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end  
```

- ** password reset test **
- rails generate integration_test password_resets
- in test/integration/password resets test

```
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
```

- in test/integration/password resets, add the test for expired token

```
  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end  
```

- in controllers, password resets controller

```
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
```

- **email in production IF YOU SET IT UP FROM BEFORE THEN YOU DONT HAVE TO AGAIN **
- heroku addons:create sendgrid:starter
- config/env/prod

```
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  host = '<your heroku app>.herokuapp.com'
  config.action_mailer.default_url_options = { host: host }
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }
```

- upload to git and heroku

```
$ rails test
$ git push
$ git push heroku
$ heroku run rails db:migrate
```

- refresh and test on live site

## Chapter 13 - user microposts

- rails generate model Micropost content:text user:references
- update the migration file

```
class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
```

-  rails db:migrate
-  has_many and belongs_to to user and microposts respectively
-  ** micropost validations **
- update micropost.rb

```
class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
end
```

- add to the test/models/micro test

```
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
```

- update micropost.rb

```
validates :content, presence: true, length: { maximum: 140 }
```

- with the 1 to many we have

```
Micropost.create
Micropost.create!
Micropost.new
we have

user.microposts.create
user.microposts.create!
user.microposts.build
```

- update test/models/micropost_test

```
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
```

### micropost refinements

- add to test/models/micropost_test

```
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
```

- update test/fixtures/microposts with

```
orange:
  content: "I just ate an orange!"
  created_at: <%= 10.minutes.ago %>

tau_manifesto:
  content: "Check out the @tauday site by @mhartl: http://tauday.com"
  created_at: <%= 3.years.ago %>

cat_video:
  content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk"
  created_at: <%= 2.hours.ago %>

most_recent:
  content: "Writing a short test"
  created_at: <%= Time.zone.now %>
```

- add to models/micropost

```
default_scope -> { order(created_at: :desc) }
```

- tests should be green
- in models/user update the has many

```
has_many :microposts, dependent: :destroy
```

- add to the test/models/user test

```
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
```

### Showing microposts

- rails db:migrate:reset
- rails db:seed
- rails generate controller Microposts
- create the file views/microposts/microposts.html.erb partial

```
<li id="micropost-<%= micropost.id %>">
  <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
  <span class="content"><%= micropost.content %></span>
  <span class="timestamp">
    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
  </span>
</li>
```

- update the show action in controllers/users controller

```
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger
  end
```

- add to views/users/show

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
  <div class="col-md-8">
    <% if @user.microposts.any? %>
      <h3>Microposts (<%= @user.microposts.count %>)</h3>
      <ol class="microposts">
        <%= render @microposts %>
      </ol>
      <%= will_paginate @microposts %>
    <% end %>
  </div>  
</div>
```

### sample microposts

- update the seed file

```
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

puts '50 posts created'
```

- restart the server
- add css to custom.scss

```
/* microposts */

.microposts {
  list-style: none;
  padding: 0;
  li {
    padding: 10px 0;
    border-top: 1px solid #e8e8e8;
  }
  .user {
    margin-top: 5em;
    padding-top: 0;
  }
  .content {
    display: block;
    margin-left: 60px;
    img {
      display: block;
      padding: 5px 0;
    }
  }
  .timestamp {
    color: $gray-light;
    display: block;
    margin-left: 60px;
  }
  .gravatar {
    float: left;
    margin-right: 10px;
    margin-top: 5px;
  }
}

aside {
  textarea {
    height: 100px;
    margin-bottom: 5px;
  }
}

span.picture {
  margin-top: 10px;
  input {
    border: 0;
  }
}
```

### profile micropost tests

- rails generate integration_test users_profile
- update the code in test/fixtures/microposts

```
orange:
  content: "I just ate an orange!"
  created_at: <%= 10.minutes.ago %>
  user: michael

tau_manifesto:
  content: "Check out the @tauday site by @mhartl: http://tauday.com"
  created_at: <%= 3.years.ago %>
  user: michael

cat_video:
  content: "Sad cats are sad: http://youtu.be/PKffm2uI4dk"
  created_at: <%= 2.hours.ago %>
  user: michael

most_recent:
  content: "Writing a short test"
  created_at: <%= Time.zone.now %>
  user: michael

<% 30.times do |n| %>
micropost_<%= n %>:
  content: <%= Faker::Lorem.sentence(5) %>
  created_at: <%= 42.days.ago %>
  user: michael
<% end %>
```

- add the code to test/inte/users profile test

```
require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
```

### manipulating microposts

- add to the routes file

```
resources :microposts,          only: [:create, :destroy]
```

- add the code to test/controllers/microposts controller test

```
  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
```

- add the code to controllers/app controller

```
  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
```

- from users controller, remove 'logged_in_user' from private, not the before action

### creating microposts

- HOW TO SERVE DIFFERENT HOME PAGES DEPENDING ON A VISITOR'S LOGIN STATUS
- update the code in controllers/microposts controller

```
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
```

- update static pages/home

```
<% if logged_in? %>
  <div class="row">
    <aside class="col-md-4">
      <section class="user_info">
        <%= render 'shared/user_info' %>
      </section>
      <section class="micropost_form">
        <%= render 'shared/micropost_form' %>
      </section>
    </aside>
  </div>
<% else %>
  <div class="center jumbotron">
    <h1>Welcome to the Sample App</h1>

    <h2>
      This is the home page for the
      <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </h2>

    <%= link_to "Sign up now!", signup_path, class: "btn btn-lg btn-primary" %>
  </div>

  <%= link_to image_tag("rails.png", alt: "Rails logo"),
              'http://rubyonrails.org/' %>
<% end %>
```

- create the partial shared/user_info

```
<%= link_to gravatar_for(current_user, size: 50), current_user %>
<h1><%= current_user.name %></h1>
<span><%= link_to "view my profile", current_user %></span>
<span><%= pluralize(current_user.microposts.count, "micropost") %></span>
```

- create the partial shared/micropost_form

```
<%= form_for(@micropost) do |f| %>
  <%= render 'shared/error_messages', object: f.object %>
  <div class="field">
    <%= f.text_area :content, placeholder: "Compose new micropost..." %>
  </div>
  <%= f.submit "Post", class: "btn btn-primary" %>
<% end %>
```

- update the home action in contr/static pages cont

```
  def home
    @micropost = current_user.microposts.build if logged_in?
  end
```

- update the code in shared/error messages

```
<% if object.errors.any? %>
  <div id="error_explanation">
    <div class="alert alert-danger">
      The form contains <%= pluralize(object.errors.count, "error") %>.
    </div>
    <ul>
    <% object.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
<% end %>
```

- in users/form partial update the code with object instead

```
<%= render 'shared/error_messages', object: f.object %>
```

- and in password resets/edit

```
<%= render 'shared/error_messages', object: f.object %>
```

- tests should be green
- refresh and test home page, make sure we see tweet form

### a proto feed

- in models user add

```
  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
  end
```

- update the code in cont/static pages contr

```
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
```

- create the status feed partial - shared/feed

```
<% if @feed_items.any? %>
  <ol class="microposts">
    <%= render @feed_items %>
  </ol>
  <%= will_paginate @feed_items %>
<% end %>
```

- update views/static pages/home

```
<% if logged_in? %>
  <div class="row">
    <aside class="col-md-4">
      <section class="user_info">
        <%= render 'shared/user_info' %>
      </section>
      <section class="micropost_form">
        <%= render 'shared/micropost_form' %>
      </section>
    </aside>
    <div class="col-md-8">
      <h3>Micropost Feed</h3>
      <%= render 'shared/feed' %>
    </div>
  </div>
<% else %>  <div class="center jumbotron">
    <h1>Welcome to the Sample App</h1>

    <h2>
      This is the home page for the
      <a href="http://www.railstutorial.org/">Ruby on Rails Tutorial</a>
      sample application.
    </h2>

    <%= link_to "Sign up now!", signup_path, class: "btn btn-lg btn-primary" %>
  </div>

  <%= link_to image_tag("rails.png", alt: "Rails logo"),
              'http://rubyonrails.org/' %>
<% end %>

```

- refresh and the posts should appear
- if you submit a blank one the page crashes
- in controller/microposts contr, update the create with an empty arr

```
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []      
      render 'static_pages/home'
    end
  end
```

### destroying microposts

- add the delete link in views/microposts/micropost partial

```
 <li id="<%= micropost.id %>">
  <%= link_to gravatar_for(micropost.user, size: 50), micropost.user %>
  <span class="user"><%= link_to micropost.user.name, micropost.user %></span>
  <span class="content"><%= micropost.content %></span>
  <span class="timestamp">
    Posted <%= time_ago_in_words(micropost.created_at) %> ago.
    <% if current_user?(micropost.user) %>
      <%= link_to "delete", micropost, method: :delete,
                                       data: { confirm: "You sure?" } %>
    <% end %>
  </span>
</li>

```

- update the code in contr/micro cont

```
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []      
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end    
end

```

### microposts tests

- add to test/fix/microposts.yml

```
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end  
```

- rails generate integration_test microposts_interface
- in test/int/microposts_interface_test

```

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
```

- in the file test/int/microposts interface test, add sidebar count

```
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "34 microposts", response.body
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end  

```

### micropost images

- HE IS USING CARRIERWAVE

## Chapter 14 - following users

- rails generate model Relationship follower_id:integer followed_id:integer
- update the migration file with

```
class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
```

- rails db:migrate
- update user.rb

```
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
```

- in relationships.rb

```
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
```

### relationship validations

- add to test/models/relationship test

```
class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
```

- add to relationship.rb

```
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true  
end

```

- delete the content in test/fixtures/relationships.yml
- test should be green

### followed users

```
Rails would see “followeds” and use the singular “followed”, assembling a collection using the followed_id in the relationships table. But, as noted in Section 14.1.1, user.followeds is rather awkward, so we’ll write user.following instead. Naturally, Rails allows us to override the default, in this case using the source parameter (as shown in Listing 14.8), which explicitly tells Rails that the source of the following array is the set of followed ids.
```

- in user.rb

```

has_many :following, through: :active_relationships, source: :followed
```

- in test/models/user_test.rb

```
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
```

- in user.rb, after the feed method before private section

```
  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
```

### followers

- in user.rb

```
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
```

- update the test in test/models/user test

```
  test "should follow and unfollow a user" do
    michael  = users(:michael)
    archer   = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
```

- tests should be green

### web interface for follwing users

- update the seeds file

```
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
```

- rails db:migrate:reset
- rails db:seed

```
Using the console, confirm that User.first.followers.count matches the value expected from Listing 14.14.
Confirm that User.first.following.count is correct as well.
```

- in routes.rb

```
  resources :users do
    member do
      get :following, :followers
    end
  end
```

- create the partial shared/stats.html

```

<% @user ||= current_user %>
<div class="stats">
  <a href="<%= following_user_path(@user) %>">
    <strong id="following" class="stat">
      <%= @user.following.count %>
    </strong>
    following
  </a>
  <a href="<%= followers_user_path(@user) %>">
    <strong id="followers" class="stat">
      <%= @user.followers.count %>
    </strong>
    followers
  </a>
</div>
```

- add the partial render to static_pages/home

```
      <section class="stats">
        <%= render 'shared/stats' %>
      </section>
```

- style the stats in css in the sidebar section

```

.stats {
  overflow: auto;
  margin-top: 0;
  padding: 0;
  a {
    float: left;
    padding: 0 10px;
    border-left: 1px solid $gray-lighter;
    color: gray;
    &:first-child {
      padding-left: 0;
      border: 0;
    }
    &:hover {
      text-decoration: none;
      color: blue;
    }
  }
  strong {
    display: block;
  }
}

.user_avatars {
  overflow: auto;
  margin-top: 10px;
  .gravatar {
    margin: 1px 1px;
  }
  a {
    padding: 0;
  }
}

.users.follow {
  padding: 0;
}
```

- create the users/follow_form partial

```
<% unless current_user?(@user) %>
  <div id="follow_form">
  <% if current_user.following?(@user) %>
    <%= render 'unfollow' %>
  <% else %>
    <%= render 'follow' %>
  <% end %>
  </div>
<% end %>
```

- in routes

```
  resources :relationships,       only: [:create, :destroy]
```

- create users/follow and users unfollow partials

```
<%= form_for(current_user.active_relationships.build) do |f| %>
  <div><%= hidden_field_tag :followed_id, @user.id %></div>
  <%= f.submit "Follow", class: "btn btn-primary" %>
<% end %>
```

```
<%= form_for(current_user.active_relationships.find_by(followed_id: @user.id),
             html: { method: :delete }) do |f| %>
  <%= f.submit "Unfollow", class: "btn" %>
<% end %>
```

- add the code to users/show

```
<% provide(:title, @user.name) %>
<div class="row">
  <aside class="col-md-4">
    <section>
      <h1>
        <%= gravatar_for @user %>
        <%= @user.name %>
      </h1>
    </section>
    <section class="stats">
      <%= render 'shared/stats' %>
    </section>
  </aside>
  <div class="col-md-8">
    <%= render 'follow_form' if logged_in? %>
    <% if @user.microposts.any? %>
      <h3>Microposts (<%= @user.microposts.count %>)</h3>
      <ol class="microposts">
        <%= render @microposts %>
      </ol>
      <%= will_paginate @microposts %>
    <% end %>
  </div>
</div>
```

### following and followers pages

- in test/controllers/users controller

```
class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  .
  .
  .
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
```

- in controller/users controller

```
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
```

- create the file views/users/show follow

```
<% provide(:title, @title) %>
<div class="row">
  <aside class="col-md-4">
    <section class="user_info">
      <%= gravatar_for @user %>
      <h1><%= @user.name %></h1>
      <span><%= link_to "view my profile", @user %></span>
      <span><b>Microposts:</b> <%= @user.microposts.count %></span>
    </section>
    <section class="stats">
      <%= render 'shared/stats' %>
      <% if @users.any? %>
        <div class="user_avatars">
          <% @users.each do |user| %>
            <%= link_to gravatar_for(user, size: 30), user %>
          <% end %>
        </div>
      <% end %>
    </section>
  </aside>
  <div class="col-md-8">
    <h3><%= @title %></h3>
    <% if @users.any? %>
      <ul class="users follow">
        <%= render @users %>
      </ul>
      <%= will_paginate %>
    <% end %>
  </div>
</div>
```

- rails generate integration_test following
- in test/fix/relationships.yml

```
one:
  follower: michael
  followed: lana

two:
  follower: michael
  followed: malory

three:
  follower: lana
  followed: michael

four:
  follower: archer
  followed: michael
```

- in test/inte/following_test

```
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
```

### A working follow button the standard way

- rails generate controller Relationships
- in test/contr/relationships contr test

```
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
```

- in contr/relationships controller

```
  before_action :logged_in_user

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end
```

- THE FOLLOWING AND UNFOLLW BUTTONS SHOULD WORK

### A working follow button with Ajax

- update the follow and unfollow partials

```
<%= form_for(current_user.active_relationships.build, remote: true) do |f| %>
  <div><%= hidden_field_tag :followed_id, @user.id %></div>
  <%= f.submit "Follow", class: "btn btn-primary" %>
<% end %>

<%= form_for(current_user.active_relationships.find_by(followed_id: @user.id),
             html: { method: :delete },
             remote: true) do |f| %>
  <%= f.submit "Unfollow", class: "btn" %>
<% end %>
```

- in contr/relationships contr

```

  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
```

- add to config/application.rb

```
    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
```

- create the file views/relationships/create.js.erb

```
$("#follow_form").html("<%= escape_javascript(render('users/unfollow')) %>");
$("#followers").html('<%= @user.followers.count %>');
```

- create views/relationships/destroy.js.erb

```
$("#follow_form").html("<%= escape_javascript(render('users/follow')) %>");
$("#followers").html('<%= @user.followers.count %>');
```

- With that, you should navigate to a user profile page and verify that you can follow and unfollow without a page refresh.

### following tests

```
This tests the standard implementation, but testing the Ajax version is almost exactly the same; the only difference is the addition of the option xhr: true:

assert_difference '@user.following.count', 1 do
  post relationships_path, params: { followed_id: @other.id }, xhr: true
end
Here xhr stands for XmlHttpRequest; setting the xhr option to true issues an Ajax request in the test, which causes the respond_to block in Listing 14.36 to execute the proper JavaScript method.
```

- in test/inte/following test

```
  def setup
    @user  = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end
  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end  
```


### The status feed

- update test/models/user test

```
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
```

```
We see from these conditions that we’ll need an array of ids corresponding to the users being followed. One way to do this is to use Ruby’s map method, available on any “enumerable” object, i.e., any object (such as an Array or a Hash) that consists of a collection of elements.9 We saw an example of this method in Section 4.3.2; as another example, we’ll use map to convert an array of integers to an array of strings:

$ rails console
>> [1, 2, 3, 4].map { |i| i.to_s }
=> ["1", "2", "3", "4"]
>> [1, 2, 3, 4].map(&:to_s)
=> ["1", "2", "3", "4"]
>> [1, 2, 3, 4].map(&:to_s).join(', ')
=> "1, 2, 3, 4"
```

- update the feed in models/user.rb

```
  # Returns a user's status feed.
  def feed
    Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

```

```
In some applications, this initial implementation might be good enough for most practical purposes, but Listing 14.44 isn’t the final implementation; see if you can make a guess about why not before moving on to the next section. (Hint: What if a user is following 5000 other users?)
```

- update models/user.rb

```
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
```

```
Of course, even the subselect won’t scale forever. For bigger sites, you would probably need to generate the feed asynchronously using a background job, but such scaling subtleties are beyond the scope of this tutorial.
```

- getting it on heroku

```
At this point, we’re ready to merge our changes into the master branch:

$ rails test
$ git add -A
$ git commit -m "Add user following"
$ git checkout master
$ git merge following-users
We can then push the code to the remote repository and deploy the application to production:

$ git push
$ git push heroku
$ heroku pg:reset DATABASE
$ heroku run rails db:migrate
$ heroku run rails db:seed
The result is a working status feed on the live Web (Figure 14.24).
```

- update test/inte/following test

```
class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end
  .
  .
  .
  test "feed on Home page" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(FILL_IN), FILL_IN
    end
  end
end
```
