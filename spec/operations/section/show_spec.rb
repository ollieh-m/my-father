require "rails_helper"

RSpec.describe Section::Show do
  include Rails.application.routes.url_helpers

  let!(:part) { create(:part) }
  let!(:section) { create(:section, part:) }

  context "With invalid params for finding a version" do
    context "With invalid part_id" do
      let(:result) { described_class.({ part_id: part.id + 1, id: section.id }) }

      it "Fails" do
        expect_failure_to_find_section(result:)
      end
    end

    context "With invalid section id" do
      let(:result) { described_class.({ part_id: part.id, id: section.id + 1 }) }

      it "Fails" do
        expect_failure_to_find_section(result:)
      end
    end

    context "Without a version" do
      let(:result) { described_class.({ part_id: part.id, id: section.id }) }

      it "Fails" do
        expect_failure_to_find_version(result:)
      end
    end
  end

  context "With an invalid version" do
    before do
      create(:version, section:, document_name: "testcard.jpg")
    end

    let(:result) { described_class.({ part_id: part.id, id: section.id }) }

    it "Fails", type: :document_upload do
      expect(result).not_to be_success
      expect(result).to be_failure
      expect(result["failure"].message).to eq "Could not read version"
      expect(result["failure"].detail).to eq "Zip end of central directory signature not found"
      expect(result["failure"].step).to eq "read"
      expect(result["failure"].go_to).to eq :show
      expect(result["failure"].type).to eq :now
    end
  end

  context "With valid part and section Ids", type: :document_upload do
    before do
      create(:version, section:, document_name: "dummy_document_1.docx")
    end

    let!(:result) { described_class.({ part_id: part.id, id: section.id }) }

    it "Succeeds" do
      expect(result).to be_success
      expect(result).not_to be_failure
    end

    it "Result does not include a failure" do
      expect(result["failure"]).to eq nil
    end

    it "Result includes the full text from the file" do
      expect(result["text"].length).to eq 77027
    end
  end

  context "With a section with multiple versions", type: :document_upload do
    before do
      create(:version, section:, document_name: "dummy_document_2.docx", created_at: 1.day.ago)
      create(:version, section:, document_name: "dummy_document_1.docx", created_at: 2.days.ago)
    end

    let!(:result) { described_class.({ part_id: part.id, id: section.id }) }

    it "Uses the most recent version" do
      expect(result["version"].document.file.filename).to eq "dummy_document_2.docx"
    end
  end

  context "With a section including a hyperlink", type: :document_upload do
    before do
      create(:version, section:, document_name: "dummy_document_with_link.docx")
    end

    let!(:result) { described_class.({ part_id: part.id, id: section.id }) }

    it "Renders the link" do
      expect(result["text"]).to include(
        "<a href=\"https://www.theguardian.com/news/2002/jan/29/guardianobituaries\" " +
        "target=\"_blank\">read one of his obituaries here</a>"
      )
    end
  end

  def expect_failure_to_find_section(result:)
    expect(result).not_to be_success
    expect(result).to be_failure
    expect(result["failure"].message).to eq "Could not find the section"
    expect(result["failure"].step).to eq "section"
    expect(result["failure"].go_to).to eq :show
    expect(result["failure"].type).to eq :now
  end

  def expect_failure_to_find_version(result:)
    expect(result).not_to be_success
    expect(result).to be_failure
    expect(result["failure"].message).to eq "Could not find a version"
    expect(result["failure"].step).to eq "version"
    expect(result["failure"].go_to).to eq :show
    expect(result["failure"].type).to eq :now
  end
end
