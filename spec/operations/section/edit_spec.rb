require 'rails_helper'

RSpec.describe Section::Edit do
  include Rails.application.routes.url_helpers

  let!(:part){ create(:part) }
  let!(:section){ create(:section, part: part) }

  context 'With invalid params for finding section' do
    context 'With invalid part_id' do
      let(:result){ described_class.({part_id: part.id + 1, id: section.id}) }

      it 'Fails' do
        expect_failure_to_find_section(result: result, section_id: section.id, part_id: part.id + 1)
      end
    end

    context 'With invalid section_id' do
      let(:result){ described_class.({part_id: part.id, id: section.id + 1}) }

      it 'Fails' do
        expect_failure_to_find_section(result: result, section_id: section.id + 1, part_id: part.id)
      end
    end
  end

  context 'With valid part and section Ids' do
    let!(:result){ described_class.({part_id: part.id, id: section.id}) }

    it 'Succeeds' do
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'Result does not include a failure' do
      expect(result['failure']).to eq nil
    end

    it 'Result includes the initialized and prepopulated form' do
      expect(result['contract.default'].versions.length).to eq 1
      model = result['contract.default'].versions.last.model
      expect(model).to be_a(Version)
      expect(model).not_to be_persisted
    end
  end

  def expect_failure_to_find_section(result:, section_id:, part_id:)
    expect(result).not_to be_success
    expect(result).to be_failure
    expect(result['failure'].message).to eq "Could not find section with ID #{section_id}"
    expect(result['failure'].step).to eq 'model'
    expect(result['failure'].go_to).to eq admin_part_sections_path(part_id: part_id)
  end
end