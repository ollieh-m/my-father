require "feature_helper"

RSpec.describe "Signing in" do

  let!(:part) { create(:part, title: "My Father (1926 - 2002)") }
  let!(:part_2) { create(:part, title: "My Father keeps the PM waiting (1970)") }
  let!(:section_1) { create(:section, part:, position: 2, title: "My father is in Who's Who") }
  let!(:section_2) { create(:section, part:, position: 1) }

  before do
    allow(ENV).to receive(:[])
    allow(ENV).to receive(:[]).with("STANDARD_PASSWORD").and_return("standard_password")
    allow(ENV).to receive(:[]).with("ADMIN_PASSWORD").and_return("admin_password")
  end

  context "As non admin" do
    scenario "With correct password" do
      visit new_session_path
      fill_in "Password", with: "standard_password"
      click_on "Enter"
      expect(current_path).to eq part_path(part)
    end

    scenario "With incorrect password" do
      visit new_session_path
      fill_in "Password", with: "incorrect_password"
      click_on "Enter"
      expect(current_path).to eq sessions_path
      expect(page).to have_content "Sorry, that password is wrong"
    end
  end

  context "As admin" do
    scenario "With correct password" do
      visit new_session_path
      fill_in "Password", with: "admin_password"
      click_on "Enter"
      expect(current_path).to eq admin_part_sections_path(part)
    end

    scenario "Via a different page" do
      visit edit_admin_part_section_path(part_id: part, id: section_1)
      fill_in "Password", with: "admin_password"
      click_on "Enter"
      expect(current_path).to eq edit_admin_part_section_path(part_id: part, id: section_1)
    end

    scenario "Via admin root page" do
      visit admin_root_path
      fill_in "Password", with: "admin_password"
      click_on "Enter"
      expect(current_path).to eq admin_part_sections_path(part)
    end

    scenario "With standard password" do
      visit admin_root_path
      fill_in "Password", with: "standard_password"
      click_on "Enter"
      expect(current_path).to eq new_session_path
    end
  end

end
