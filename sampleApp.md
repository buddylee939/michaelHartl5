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
- 
