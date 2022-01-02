require 'feature_helper'

RSpec.describe 'User views introduction to a part' do

  before do
    mock_standard_access
  end

  let(:part_1){ create(:part, title: "My Father keeps the PM waiting (1970)", param: "pm_waiting_1970") }
  let(:part_2){ create(:part) }

  context 'successfully' do
    scenario 'seeing the correct introductory text' do
      visit part_path(part_1)

      within '.page' do
        expect(page).to have_content "My Father keeps the PM waiting (1970)"
        expect(page).to have_content "It's June 1970, and for My Father, the next few days will determine the course of the rest of his life."
      end
    end
  end

  context 'unsuccessfully' do
    scenario 'because there is no introductory text for the part' do
      visit part_path(part_2)

      within '.page' do
        expect(page).to have_content part_2.title
      end
    end
  end
end
