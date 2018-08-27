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

- 