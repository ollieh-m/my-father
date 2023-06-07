require "feature_helper"

RSpec.describe "Admin adds a version to a chapter" do

  before do
    mock_admin_access
  end

  let!(:part) { create(:part) }
  let!(:section) { create(:section, part:) }

  context "Successfully" do
    scenario "and it appears in the list of versions", type: :document_upload, js: true do
      visit admin_part_sections_path(part)
      click_on "Edit"
      add_version
      expect(page).to have_content "dummy_document_1.docx"
      expect(section.reload.versions.count).to eq 1
      expect(section.versions.last.document.file.filename).to eq "dummy_document_1.docx"
    end

    scenario "successfully after a validation error on the title attribute", type: :document_upload, js: true do
      visit admin_part_sections_path(part)
      click_on "Edit"
      fill_in "Title", with: ""
      click_on "Update"
      expect(page).to have_content "can't be blank"
      fill_in "Title", with: "New title"
      add_version
      expect(page).to have_content "dummy_document_1.docx"
      expect(section.reload.versions.count).to eq 1
      expect(section.versions.last.document.file.filename).to eq "dummy_document_1.docx"
      expect(section.title).to eq "New title"
    end

    scenario "successfully after a validation error from an empty attachment", js: true do
      visit admin_part_sections_path(part)
      click_on "Edit"
      fill_in "Title", with: "New title"
      click_on "Add new version"
      click_on "Update"
      expect(page).to have_content "a new version must have an attachment"
      click_on "Undo"
      click_on "Update"
      expect(section.reload.title).to eq "New title"
    end

    scenario "successfully after a validation error from an invalid attachment", type: :document_upload, js: true do
      visit admin_part_sections_path(part)
      click_on "Edit"
      fill_in "Title", with: "New title"
      add_version("testcard.jpg")
      expect(page).to have_content "only .docx files are allowed"
      # check that simply resubmitting doesn't bypass validation
      click_on "Update"
      expect(page).to have_content "a new version must have an attachment"
      attach_file "Choose file", Rails.root.join("spec/support/dummy_documents/dummy_document_1.docx"), make_visible: true
      click_on "Update"
      expect(page).to have_content "dummy_document_1.docx"
      expect(section.reload.versions.count).to eq 1
      expect(section.versions.last.document.file.filename).to eq "dummy_document_1.docx"
      expect(section.title).to eq "New title"
    end

    scenario "successfully after an invalid title then an invalid attachment then fixing both issues", type: :document_upload,
js: true do
      visit admin_part_sections_path(part)
      click_on "Edit"
      # submit with invalid title
      fill_in "Title", with: ""
      add_version
      expect(page).to have_content "can't be blank"
      # correct title but change attachment to be invalid
      fill_in "Title", with: "New title"
      attach_file "Choose file", Rails.root.join("spec/support/dummy_documents/testcard.jpg"), make_visible: true
      click_on "Update"
      expect(page).to have_content "only .docx files are allowed"
      # check that simply resubmitting does not send the initial, valid attachment
      click_on "Update"
      expect(page).to have_content "a new version must have an attachment"
      # attach a valid file
      attach_file "Choose file", Rails.root.join("spec/support/dummy_documents/dummy_document_1.docx"), make_visible: true
      click_on "Update"
      expect(page).to have_content "dummy_document_1.docx"
      expect(section.reload.versions.count).to eq 1
      expect(section.versions.last.document.file.filename).to eq "dummy_document_1.docx"
      expect(section.title).to eq "New title"
    end
  end

  context "Unsuccessfully" do
    scenario "because the chapter does not exist" do
      visit edit_admin_part_section_path(part_id: part, id: "foo")
      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content "Could not find section with ID foo"
    end

    scenario "because the chapter is not in the given part" do
      part_2 = create(:part)
      visit edit_admin_part_section_path(part_id: part_2, id: section)
      expect(current_path).to eq admin_part_sections_path(part_2)
      expect(page).to have_content "Could not find section with ID #{section.id}"
    end

    scenario "because the part does not exist" do
      visit edit_admin_part_section_path(part_id: "foo", id: section)
      expect(current_path).to eq admin_part_sections_path(part)
      expect(page).to have_content "Could not find part with ID foo"
    end
  end

end
