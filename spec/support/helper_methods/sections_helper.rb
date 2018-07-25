module SectionsHelper

  def create_section(title:)
    click_on 'Add'
    fill_in 'create_section_title', with: title
    click_on 'Create'
  end

end

RSpec.configure do |config|
  config.include SectionsHelper, :type => :feature
end
