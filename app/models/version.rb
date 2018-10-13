class Version < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :section
end
