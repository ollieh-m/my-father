FactoryBot.define do
  factory :version do
    transient do
      document_name { "dummy_document_1.docx" }
    end

    document { Rack::Test::UploadedFile.new(Rails.root.join("spec", "support", "dummy_documents", document_name)) }
    section
  end
end
