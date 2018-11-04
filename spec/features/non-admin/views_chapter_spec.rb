require 'feature_helper'

RSpec.describe 'User views latest version of a chapter' do

  let!(:part){ create(:part) }
  let!(:section){ create(:section, part: part) }

  context 'successfully' do
	  scenario 'seeing the text from the uploaded file', type: :document_upload do
  		create(:version, section: section, document_name: 'dummy_document_1.docx')
	    visit part_section_path(part_id: part, id: section)

	    within '.text' do
	    	expect(page).to have_content 'Monday 15 June 1970'
	    	expect(page).to have_content 'CAN LABOUR STILL SNATCH DEFEAT FROM JAWS OF VICTORY?'
	    end
	  end
	end

	context 'unsuccessfully' do
	  scenario 'because the section has no versions uploaded' do
	  	visit part_section_path(part_id: part, id: section)

	    within '.flash-alert' do
	    	expect(page).to have_content 'Could not find a version'
	    end

	    within '.text' do
	    	expect(page).to have_content 'Nothing to read...'
	    end
	  end

	  scenario 'because the version cannot be read', type: :document_upload do
	  	create(:version, section: section, document_name: 'dummy_document_1.docx')
	  	allow(Docx::Document).to receive(:open).and_raise("invalid format")

	  	visit part_section_path(part_id: part, id: section)

	  	within '.flash-alert' do
	    	expect(page).to have_content 'Could not read version'
	    end

	    within '.text' do
	    	expect(page).to have_content 'invalid format'
	    end
	  end

	  scenario 'because the section does not exist' do
	  	visit part_section_path(part_id: part, id: section.id + 1)

	  	within '.flash-alert' do
	    	expect(page).to have_content 'Could not find a version'
	    end

	    within '.text' do
	    	expect(page).to have_content 'Nothing to read...'
	    end
	  end
	end

end