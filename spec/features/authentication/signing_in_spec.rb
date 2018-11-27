require 'feature_helper'

RSpec.describe 'Signing in' do

	let!(:part){ create(:part) }
  let!(:section_1){ create(:section, part: part, position: 2) }
  let!(:section_2){ create(:section, part: part, position: 1) }

	before do
		allow(ENV).to receive(:[])
		allow(ENV).to receive(:[]).with('STANDARD_PASSWORD').and_return('standard_password')
		allow(ENV).to receive(:[]).with('ADMIN_PASSWORD').and_return('admin_password')
	end

  context 'As non admin' do
  	scenario 'With correct password' do
  		visit new_session_path
  		fill_in 'Password', with: 'standard_password'
  		click_on 'Enter'
  		expect(current_path).to eq part_section_path(part_id: part, id: section_2)
	 	end

	 	scenario 'Via a different page' do
	 		visit part_section_path(part_id: part, id: section_1)
	 		fill_in 'Password', with: 'standard_password'
	 		click_on 'Enter'
  		expect(current_path).to eq part_section_path(part_id: part, id: section_1)
	 	end

	 	scenario 'Via root page' do
	 		visit root_path
	 		fill_in 'Password', with: 'standard_password'
	 		click_on 'Enter'
  		active_arrow = find('.menu__section', text: 'About').find_all('.arrow.active')
  		expect(active_arrow.length).to eq 1
	 	end

	 	scenario 'With incorrect password' do
	 		visit new_session_path
  		fill_in 'Password', with: 'incorrect_password'
  		click_on 'Enter'
  		expect(current_path).to eq sessions_path
  		expect(page).to have_content "Sorry, that password is wrong"
	 	end
  end

 end