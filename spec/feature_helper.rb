# require 'feature_helper' in feature tests

require 'rails_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {timeout: 100, js_errors: true})
end

Capybara.javascript_driver = :poltergeist

Capybara.enable_aria_label = true