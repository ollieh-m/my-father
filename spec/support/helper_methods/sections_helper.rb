module SectionsHelper

  def create_section(title:)
    click_on 'Add'
    fill_in 'create_section_title', with: title
    click_on 'Create'
  end

  def add_version
    click_on 'Add new version'
    attach_file "Select attachment", Rails.root.join('spec','support','dummy_documents','dummy_document_1.docx')
    click_on 'Update'
  end

end

RSpec.configure do |config|
  config.include SectionsHelper, :type => :feature
end
