require 'feature_helper'

RSpec.describe 'Admin creates a new chapter' do

  let!(:part){ create(:part) }

  scenario 'It appears in the chapter list', js: true do
    visit admin_part_sections_path(part)
    create_section(title: 'A new section')
    expect(current_path).to eq admin_part_sections_path(part)
    expect(page).to have_content('A new section')
  end

end
