class EditSectionForm < Reform::Form
  validates :title, presence: true

  property :title

  collection :versions, form: VersionForm, populate_if_empty: Version, prepopulator: :ensure_empty_version

  def ensure_empty_version(**options)
    unless self.versions.any? { |version| !version.id }
      self.versions << Version.new
    end
  end
end
