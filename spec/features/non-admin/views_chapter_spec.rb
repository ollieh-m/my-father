require 'feature_helper'

RSpec.describe 'User views latest version of a chapter' do

  let!(:part){ create(:part) }
  let!(:section){ create(:section, part: part) }
  let!(:version_1){ create(:version, section: section, document_name: 'dummy_document_1.docx') }
  let!(:version_2){ create(:version, section: section, document_name: 'dummy_document_2.docx') }

  scenario 'successfully', type: :document_upload do
    visit part_section_path(part_id: part, id: section)

    save_and_open_page

  end
end