class EditSectionForm < Reform::Form
  validates :title, presence: true

  property :title

  collection :versions,
    form: VersionForm,
    populate_if_empty: Version,
    prepopulator: :ensure_empty_version

  def mapper_for(model)
    # Custom mapper lets us use `versions.oldest_first`
    # when reading from the model to set `versions` in the form.
    # This ensures
    # a) versions are shown in the correct order on the page, and
    # b) they are ordered the same in this form when the params are deserialized
    # (i.e. when attributes for the first version in the params are assigned to versions[0],
    # they are assigned to the correct version)
    SectionFormMapper.new(model)
  end

  def ensure_empty_version(**options)
    unless self.versions.any? { |version| !version.id }
      self.versions << Version.new
    end
  end
end
