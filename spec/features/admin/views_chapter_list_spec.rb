require "feature_helper"

RSpec.describe "Admin views chapters in a part" do

  before do
    mock_admin_access
  end

  let!(:part_1) { create(:part) }
  let!(:part_2) { create(:part) }

  let!(:section_1) { create(:section, part: part_1, position: 4) }
  let!(:section_2) { create(:section, part: part_1, position: 2) }
  let!(:section_3) { create(:section, part: part_2) }
  let!(:section_4) { create(:section, part: part_2) }

  context "Successfully" do

    scenario "and only sees chapters in the given part" do
      visit admin_part_sections_path(part_1)

      expect(page).to have_content(section_1.title)
      expect(page).to have_content(section_2.title)
      expect(page).not_to have_content(section_3.title)
      expect(page).not_to have_content(section_4.title)

      expect(page).to have_link("Edit", href: edit_admin_part_section_path(part_id: part_1, id: section_1))
      expect(page).to have_link("Edit", href: edit_admin_part_section_path(part_id: part_1, id: section_2))
      expect(page).not_to have_link("Edit", href: edit_admin_part_section_path(part_id: part_1, id: section_3))
      expect(page).not_to have_link("Edit", href: edit_admin_part_section_path(part_id: part_1, id: section_4))
    end

    scenario "and in the correct order" do
      visit admin_part_sections_path(part_1)

      sections = all(".list-item")

      within sections[0] do
        expect(page).to have_content(section_2.title)
      end
      within sections[1] do
        expect(page).to have_content(section_1.title)
      end
    end

  end
end
