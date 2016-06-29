# License: MIT
#
# On loading the different pages the script waits 10 seconds for the content to appear. If you have a slow connection or their server is under load you should try to increase that timeout.

#== require gems ==#
require 'rubygems' # gems
require 'open-uri' # uri tools
require 'watir-webdriver' # open & interact with browser
require 'phantomjs' # headless browser
require 'pony' # email
require 'dotenv' # env configuration

# load config
Dotenv.load
# setup phantomjs
Selenium::WebDriver::PhantomJS.path = ENV['PHANTOMJS']

#== variables ==#
button_class = "twelve-days-claim" # class of the button to get free book
base_url = "https://www.packtpub.com/" # base url
free_learning_url = "https://www.packtpub.com/packt/offers/free-learning" # url of the free book
timeout = 10

# create browser
browser = Watir::Browser.new :phantomjs # open new browser
browser.window.resize_to(1920, 1080) # go full width because we are mobile otherwise

# login
browser.goto base_url # go to base url
browser.a(class: 'login-popup').when_present(timeout).click # wait till page is loaded
browser.form(id: 'packt-user-login-form').text_field(name: 'email').set(ENV['PACKTPUB_EMAIL']) # enter email
browser.form(id: 'packt-user-login-form').text_field(name: 'password').set(ENV['PACKTPUB_PASSWORD']) # enter password
browser.form(id: 'packt-user-login-form').button(type: 'submit').click # click login button
browser.div(id: 'account-bar-logged-in').wait_until_present(timeout) # user is logged in

# get free book
browser.goto free_learning_url # go to free book url
book_title = browser.div(class: 'dotd-title').when_present(timeout).h2.text # get book title
browser.a(class: 'twelve-days-claim').when_present(timeout).click # click the button to receive the free book
#browser.screenshot.save 'screenshot.png' # comment in for debugging
browser.close # close phantomjs

#== send email ==#
if ENV['SEND_NOTIFICATION'] == 'true'
  message = "Added new free book to your library: #{book_title}"
  Pony.mail(
    to: ENV['PACKTPUB_EMAIL'],
    from: ENV['MAIL_SENDER'],
    subject: "[New packtpub book] - #{book_title}",
    body: message)
end
