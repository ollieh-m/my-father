require 'spec_helper'

RSpec.describe Section::Index do
  let(:part){ create(:part) }

  context 'With invalid part ID' do
    let!(:result){ described_class.({part_id: part.id + 1}) }

    it 'Fails' do
      expect(result).not_to be_success
      expect(result).to be_failure
    end

    it 'Result includes a failure with the correct message' do
      expect(result['failure'].message).to eq "Could not find part with ID #{part.id + 1}"
    end

    it 'Result includes a failure with the correct step' do
      expect(result['failure'].step).to eq 'part'
    end
  end

  context 'With valid part' do
    let!(:result){ described_class.({part_id: part.id}) }

    it 'Succeeds' do
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'Result does not include a failure' do
      expect(result['failure']).to eq nil
    end

    it 'Result includes a new section form' do
      expect(result['contract.default'].model).not_to be_persisted
      expect(result['contract.default'].model.class).to eq Section
      expect(result['contract.default'].title).to eq nil
      expect(result['contract.default'].class).to eq CreateSectionForm
    end
  end
end
