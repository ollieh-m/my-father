class Version < ApplicationRecord
  mount_uploader :document, DocumentUploader

  belongs_to :section

  scope :oldest_first, -> { order(created_at: :asc, id: :asc) }
end
