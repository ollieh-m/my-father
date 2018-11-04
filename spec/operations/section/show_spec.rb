require 'rails_helper'

RSpec.describe Section::Show do
  include Rails.application.routes.url_helpers

  let!(:part){ create(:part) }
  let!(:section){ create(:section, part: part) }

  context 'With invalid params for finding a version' do
    context 'With invalid part_id' do
      let(:result){ described_class.({part_id: part.id + 1, id: section.id}) }

      it 'Fails' do
        expect_failure_to_find_version(result: result)
      end
    end

    context 'With invalid section id' do
      let(:result){ described_class.({part_id: part.id, id: section.id + 1}) }

      it 'Fails' do
        expect_failure_to_find_version(result: result)
      end
    end

    context 'Without a version' do
    	let(:result){ described_class.({part_id: part.id, id: section.id}) }

      it 'Fails' do
        expect_failure_to_find_version(result: result)
      end
    end
  end

  context 'With an invalid version' do
  	before do
  		create(:version, section: section, document_name: 'testcard.jpg')
  	end

  	let(:result){ described_class.({part_id: part.id, id: section.id}) }

  	it 'Fails', type: :document_upload do
  		expect(result).not_to be_success
		  expect(result).to be_failure
		  expect(result['failure'].message).to eq "Could not read version"
		  expect(result['failure'].detail).to eq "Zip end of central directory signature not found"
		  expect(result['failure'].step).to eq 'read'
		  expect(result['failure'].go_to).to eq :show
		  expect(result['failure'].type).to eq :now
  	end
  end

  context 'With valid part and section Ids', type: :document_upload do
    before do
  		create(:version, section: section, document_name: 'dummy_document_1.docx')
  	end

    let!(:result){ described_class.({part_id: part.id, id: section.id}) }

    it 'Succeeds' do
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'Result does not include a failure' do
      expect(result['failure']).to eq nil
    end

    it 'Result includes the full text from the file' do
      expect(result['text'].length).to eq 77027
    end
  end
end

def expect_failure_to_find_version(result:)
  expect(result).not_to be_success
  expect(result).to be_failure
  expect(result['failure'].message).to eq "Could not find a version"
  expect(result['failure'].step).to eq 'version'
  expect(result['failure'].go_to).to eq :show
  expect(result['failure'].type).to eq :now
end
