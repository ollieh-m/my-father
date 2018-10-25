require 'feature_helper'

RSpec.describe 'Admin creates a new chapter' do

  let!(:part){ create(:part) }

  context 'Successfully' do
    scenario 'and it appears in the chapter list', js: true do
      visit admin_part_sections_path(part)
      create_section(title: 'A new section')

      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content('A new section')
      expect(page).to have_link('Edit', href: edit_admin_part_section_path(part_id: part, id: Section.last))

      expect(Section.all.count).to eq 1
      expect(Section.last.title).to eq 'A new section'
      expect(Section.last.part).to eq part
    end

    scenario 'after initially providing invalid data', js: true do
      visit admin_part_sections_path(part)
      create_section(title: '')

      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content("can't be blank")
      expect(Section.all.count).to eq 0

      fill_in 'create_section_title', with: 'A valid title'
      click_on 'Create'

      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_link('Edit', href: edit_admin_part_section_path(part_id: part, id: Section.last))
      expect(Section.last.title).to eq 'A valid title'
      expect(Section.last.part).to eq part
    end

    scenario 'multiple times', js: true do
      visit admin_part_sections_path(part)
      create_section(title: 'A new section 1')
      create_section(title: 'A new section 2')

      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content('A new section 1')
      expect(page).to have_content('A new section 2')

      expect(page).to have_link('Edit', href: edit_admin_part_section_path(part_id: part, id: Section.find_by(title: 'A new section 1')))
      expect(page).to have_link('Edit', href: edit_admin_part_section_path(part_id: part, id: Section.find_by(title: 'A new section 2')))

      expect(Section.all.count).to eq 2
    end

    scenario 'after initially trying to add the section to a non-existent part', js: true do
      visit admin_part_sections_path(part_id: 2)
      expect(page).to have_css('div.flash-alert', text: 'Could not find part with ID 2')
      expect(current_path).to eq admin_part_sections_path(part)

      create_section(title: 'A new section')

      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content('A new section')
      expect(page).to have_link('Edit', href: edit_admin_part_section_path(part_id: part, id: Section.last))

      expect(Section.all.count).to eq 1
      expect(Section.last.title).to eq 'A new section'
      expect(Section.last.part).to eq part
    end
  end
end
