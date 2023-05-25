# require 'feature_helper' in feature tests

require 'rails_helper'
require 'capybara/rspec'
require 'selenium/webdriver'

Capybara.javascript_driver = :selenium_headless

Capybara.enable_aria_label = true
