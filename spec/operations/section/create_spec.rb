require 'rails_helper'

RSpec.describe Section::Create do
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

  context 'With invalid section params' do
    # TO DO: operation should be able to receive params as strings or symbols
    let!(:result){ described_class.({part_id: part.id, 'create_section' => {title: ''}}) }

    it 'Fails' do
      expect(result).not_to be_success
      expect(result).to be_failure
    end

    it 'Result includes a failure without a message' do
      expect(result['failure'].message).to eq nil
    end

    it 'Result includes a failure with the correct step' do
      expect(result['failure'].step).to eq 'contract.default.validate'
    end

    it 'Result includes the form errors' do
      expect(result['contract.default'].errors[:title]).to eq ["can't be blank"]
    end
  end

  context 'With valid part and section params' do
    # TO DO: operation should be able to receive params as strings or symbols
    let!(:result){ described_class.({part_id: part.id, 'create_section' => {title: 'A title'}}) }

    it 'Succeeds' do
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it 'Result does not include a failure' do
      expect(result['failure']).to eq nil
    end

    it 'Result includes the newly persisted section' do
      expect(result['model']).to be_persisted
      expect(result['model'].title).to eq 'A title'
    end
  end

  context 'Automatically setting the correct position' do
    before do
      create(:section, part: part, position: 1)
    end

    it 'Rescues from duplicates caused by race conditions' do
      wait_for_it  = true

      threads = 2.times.map do |i|
        Thread.new do
          true while wait_for_it
          described_class.({part_id: part.id, 'create_section' => {title: "A title #{i}"}})
        end
      end
      wait_for_it = false
      threads.each(&:join)

      section_2 = Section.find_by(title: "A title 0")
      section_3 = Section.find_by(title: "A title 1")
      expect(section_2.position).not_to eq section_3.position
    end
  end

end
