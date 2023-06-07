require "feature_helper"

RSpec.describe "Admin deletes a chapter" do

  before do
    mock_admin_access
  end

  let!(:part) { create(:part) }
  let!(:section) { create(:section, part:, title: "Chapter to delete") }
  let!(:section_2) { create(:section, part:, title: "Chapter not to delete") }

  context "Successfully" do
    scenario "and the correct chapter is removed from the list", js: true do
      visit admin_part_sections_path(part)
      delete_chapter

      expect(page).not_to have_css(".list-item", text: "Chapter to delete")
      expect(page).to have_content "Chapter not to delete"
    end

    scenario "and it's versions are also deleted", js: true do
      create(:version, section:)

      visit admin_part_sections_path(part)
      delete_chapter

      expect(page).not_to have_css(".list-item", text: "Chapter to delete")
      expect(Version.count).to eq 0
    end

    def delete_chapter
      click_on "Delete Chapter to delete"
      expect(page).to have_content "Are you sure you want to delete Chapter to delete? This cannot be undone"
      click_on "Yes, delete"
    end
  end
end
