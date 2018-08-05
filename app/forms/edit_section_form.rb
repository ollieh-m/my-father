class EditSectionForm < Reform::Form

  property :title

  # match up input with a new model if there is no ID in the input; match up with existing model using ID otherwise;
  # if the model is persisted already, mark for deletion or else do nothing
  collection :versions, form: VersionForm, populate_if_empty: Version, prepopulator: ->(options) { self.versions << Version.new }

  validation do
    required(:title).filled
  end

end
