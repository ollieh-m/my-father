class EditSectionForm < Reform::Form

  validates :title, presence: true

  property :title

  collection :versions, form: VersionForm, populate_if_empty: Version, prepopulator: ->(options) { self.versions << Version.new }

end
