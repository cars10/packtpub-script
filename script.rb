#== Script to automatically add free packtpublishing book to your library ==#
# Setup
# install `phantomjs`
# ## create .ruby-version file and add the ruby version, for example ruby-2.3.0
# ## create .ruby-gemset file and add a gemset, for example packt-script
# ## run `bundle install`
# run the script with: "ruby script.rb". i recommend to setup a cron to run it daily

#== require gems ==#
require 'rubygems' # gems
require 'open-uri' # uri tools
require 'watir-webdriver' # open & interact with browser
require 'webdriver-user-agent'
require 'phantomjs' # headless browser
require 'pony' # email
require 'dotenv'
Dotenv.load
Selenium::WebDriver::PhantomJS.path = ENV['PHANTOMJS']

#== variables ==#
button_class = "twelve-days-claim"
base_url = "https://www.packtpub.com/"
free_learning_url = "https://www.packtpub.com/packt/offers/free-learning"

# create browser
browser = Watir::Browser.new :phantomjs # open new browser
browser.window.resize_to(1920, 1080) # go full width because we are mobile otherwise

# login
browser.goto base_url # go to url
browser.a(class: 'login-popup').when_present(5).click # wait till page is loaded
browser.form(id: 'packt-user-login-form').text_field(name: 'email').set(ENV['PACKTPUB_EMAIL'])
browser.form(id: 'packt-user-login-form').text_field(name: 'password').set(ENV['PACKTPUB_PASSWORD'])
browser.form(id: 'packt-user-login-form').button(type: 'submit').click
browser.div(id: 'account-bar-logged-in').wait_until_present(5) # user is logged in

# get free book
browser.goto free_learning_url # go to url
book_title = browser.div(class: 'dotd-title').when_present(5).h2.text
browser.a(class: 'twelve-days-claim').when_present(5).click
#browser.screenshot.save 'screenshot.png'
browser.close

#== email ==#
message = "Added new book: #{book_title}"

Pony.mail(to: ENV['PACKTPUB_EMAIL'], from: ENV['MAIL_SENDER'], subject: 'New packtpub book', body: message)
