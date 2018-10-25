class CreateSectionForm < Reform::Form

  validates :title, presence: true

  property :title

end
