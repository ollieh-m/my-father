require 'feature_helper'

RSpec.describe 'Admin creates a new chapter' do

  before do

  end

  scenario 'It appears in the chapter list', js: true do
    visit admin_part_sections_path(1)
  end

end
