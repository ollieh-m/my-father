require 'feature_helper'

RSpec.describe 'Admin adds a version to a chapter' do

  let!(:part){ create(:part) }
  let!(:section){ create(:section, part: part) }

  context 'Successfully' do
    scenario 'and it appears in the chapter list' do
      visit admin_part_sections_path(part)
      click_on 'Edit'
      save_and_open_page
    end
  end

  context 'Unsuccessfully' do
    scenario 'because the chapter does not exist' do
      visit edit_admin_part_section_path(part_id: part, id: 'foo')
      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content 'Could not find section with ID foo'
    end

    scenario 'because the chapter is not in the given part' do
      part_2 = create(:part)
      visit edit_admin_part_section_path(part_id: part_2, id: section)
      expect(current_path).to eq admin_part_sections_path(part_2)
      expect(page).to have_content "Could not find section with ID #{section.id}"
    end

    scenario 'because the part does not exist' do
      visit edit_admin_part_section_path(part_id: 'foo', id: section)
      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content "Could not find part with ID foo"
    end
  end

end
