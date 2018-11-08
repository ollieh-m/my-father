class EditSectionForm < Reform::Form

  validates :title, presence: true

  property :title

  collection :versions, form: VersionForm, populator: :populate_version!, prepopulator: ->(options) { self.versions << Version.new }

  # match up input with a new model wrapped in a form if there is no ID in the input
  # match up with existing model wrapped in a form using ID otherwise
  # but do not serialize input onto form - just mark the model for destruction if it is being removed
  def populate_version!(fragment:, **)
    item = versions.find { |version| version.id.to_s == fragment["id"].to_s }

    if item
    	versions.delete(item) if fragment["delete"] == "1"
      return skip!
    end

    versions.append(Version.new)
  end

end
