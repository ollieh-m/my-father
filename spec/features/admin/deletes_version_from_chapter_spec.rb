require 'feature_helper'

RSpec.describe 'Admin removes a version from a section' do

  before do
    mock_admin_access
  end

  let!(:part){ create(:part) }
  let!(:section){ create(:section, part: part) }
  let!(:version_1){ create(:version, section: section, document_name: 'dummy_document_1.docx') }
  let!(:version_2){ create(:version, section: section, document_name: 'dummy_document_2.docx') }

  scenario 'successfully', type: :document_upload, js: true do
    visit admin_part_sections_path(part)
    click_on 'Edit'
    versions = all('.existing-version', count: 2)
    remove_version(versions[0])
    expect(page).not_to have_content 'dummy_document_1.docx'
    expect(section.reload.versions.count).to eq 1
  end

  scenario 'submits invalid data then decides to keep version', type: :document_upload, js: true do
    visit admin_part_sections_path(part)
    click_on 'Edit'
    versions = all('.existing-version', count: 2)
    fill_in 'Title', with: ''
    remove_version(versions[0])
    expect(page).to have_content "can't be blank"
    expect(page).to have_content 'dummy_document_1.docx'

    versions = all('.existing-version', count: 2)
    within(versions[0]) do
      uncheck 'Delete'
    end
    click_on 'Update'
    expect(page).to have_content 'dummy_document_1.docx'
    expect(section.reload.versions.count).to eq 2
  end

end
