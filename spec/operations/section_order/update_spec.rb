require 'rails_helper'

RSpec.describe SectionOrder::Update do

  let!(:part){ create(:part) }
  let!(:section_1){ create(:section, part: part) }
  let!(:section_2){ create(:section, part: part) }
  let!(:section_3){ create(:section, part: part) }
  let!(:section_4){ create(:section) }

  scenario 'Passing in a valid array of sections' do
  	array = ["section_#{section_2.id}", "section_#{section_3.id}", "section_#{section_1.id}"]
  	result = described_class.({:part_id => part.id, :ordered_sections => array})
  	expect(result.success?).to eq true
  	expect(section_1.reload.position).to eq 3
  	expect(section_2.reload.position).to eq 1
  	expect(section_3.reload.position).to eq 2
  end

  scenario 'Passing in an array with an invalid section' do
  	array = ["section_#{section_2.id}", "section_#{section_3.id}", "section_#{section_4.id}"]
  	result = described_class.({:part_id => part.id, :ordered_sections => array})
  	expect(result.success?).to eq false
    expect(result['failure'].message).to eq "Sections are invalid"
  	expect(section_2.reload.position).to eq nil
  	expect(section_3.reload.position).to eq nil
  	expect(section_4.reload.position).to eq nil
  end

  scenario 'Passing in an array that excludes a section' do
  	array = ["section_#{section_2.id}", "section_#{section_3.id}"]
  	result = described_class.({:part_id => part.id, :ordered_sections => array})
  	expect(result.success?).to eq false
    expect(result['failure'].message).to eq "Sections are invalid"
  	expect(section_2.reload.position).to eq nil
  	expect(section_3.reload.position).to eq nil
  end

  scenario 'Passing in an invalid part' do
    result = described_class.({:part_id => part.id + 2})
    expect(result.success?).to eq false
    expect(result['failure'].message).to eq "Could not find part with ID #{part.id + 2}"
  end

end


