# require 'feature_helper' in feature tests

require 'rails_helper'
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.register_driver :headless_chrome do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--disable-extensions'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--no-sandbox'
  browser_options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.javascript_driver = :headless_chrome

Capybara.enable_aria_label = true
