require "rails_helper"

RSpec.describe Section::Update do
  include Rails.application.routes.url_helpers

  let!(:part) { create(:part) }
  let!(:section) { create(:section, part:) }

  context "With invalid params for finding section" do
    context "With invalid part_id" do
      let(:result) { described_class.({ part_id: part.id + 1, id: section.id }) }

      it "Fails" do
        expect_failure_to_find_section(result:, section_id: section.id, part_id: part.id + 1)
      end
    end

    context "With invalid section_id" do
      let(:result) { described_class.({ part_id: part.id, id: section.id + 1 }) }

      it "Fails" do
        expect_failure_to_find_section(result:, section_id: section.id + 1, part_id: part.id)
      end
    end
  end

  context "With invalid section params" do
    # TO DO: operation should be able to receive params as strings or symbols
    let!(:result) { described_class.({ part_id: part.id, id: section.id, "edit_section" => { title: "" } }) }

    it "Fails" do
      expect(result).not_to be_success
      expect(result).to be_failure
    end

    it "Result includes a failure without a message" do
      expect(result["failure"].message).to eq nil
    end

    it "Result includes a failure with the correct step" do
      expect(result["failure"].step).to eq "contract.default.validate"
    end

    it "Result includes the form errors" do
      expect(result["contract.default"].errors[:title]).to eq ["can't be blank"]
    end
  end

  context "With valid params for finding and updating section", type: :document_upload do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec/support/dummy_documents/dummy_document_1.docx")) }
    let!(:result) {
 described_class.({ part_id: part.id, id: section.id, "edit_section" => { title: "A title", versions: [document: file] } }) }

    it "Succeeds" do
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it "Result does not include a failure" do
      expect(result["failure"]).to eq nil
    end

    it "Result includes the updated section" do
      expect(result["model"].versions.count).to eq 1
      expect(result["model"].title).to eq "A title"
    end
  end
end

def expect_failure_to_find_section(result:, section_id:, part_id:)
  expect(result).not_to be_success
  expect(result).to be_failure
  expect(result["failure"].message).to eq "Could not find section with ID #{section_id}"
  expect(result["failure"].step).to eq "model"
  expect(result["failure"].go_to).to eq admin_part_sections_path(part_id:)
end
