module SectionsHelper

  def create_section(title:)
    click_on 'Add'
    fill_in 'Title', with: title
    click_on 'Confirm'
  end

end

RSpec.configure do |config|
  config.include SectionsHelper, :type => :feature
end
