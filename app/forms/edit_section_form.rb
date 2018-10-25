class EditSectionForm < Reform::Form

  validates :title, presence: true

  property :title

  # match up input with a new model wrapped in a form if there is no ID in the input
  # match up with existing model wrapped in a form using ID otherwise,
  # but do not serialize input onto form - just mark the model for destruction if it is being removed
  collection :versions, form: VersionForm, populate_if_empty: Version, prepopulator: ->(options) { self.versions << Version.new }

end
