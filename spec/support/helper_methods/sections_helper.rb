module SectionsHelper

  def create_section(title:)
    click_on 'Add'
    fill_in 'create_section_title', with: title
    click_on 'Create'
  end

  def add_version(dummy_document='dummy_document_1.docx')
    click_on 'Add new version'
    attach_file "Choose file", Rails.root.join('spec','support','dummy_documents',dummy_document), make_visible: true
    click_on 'Update'
  end

  def remove_version(version)
    within(version) do
      find('label', text: 'Delete').click
    end
    click_on 'Update'
  end

end

RSpec.configure do |config|
  config.include SectionsHelper, :type => :feature
end
