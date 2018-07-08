# require 'feature_helper' in feature tests

require 'rails_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
