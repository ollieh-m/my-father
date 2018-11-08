class VersionForm < Reform::Form

  validate :document_attached

  property :id, writeable: false
  property :delete, virtual: true
  property :document, skip_if: :marked_for_deletion
  property :document_cache, skip_if: :marked_for_deletion

  def deserialize!(input)
    # set document_cache in case of re-render
    input['document_cache'] = Version.new(document: input['document']).document_cache if new_attachment?(input['document'])
    super(input)
  end

  def marked_for_deletion(fragment, *)
    fragment["delete"] == "1"
  end

  def document_cache_name
    document_cache.split('/').last if document_cache
  end

  def new_attachment?(document)
    document.class.to_s.include?('UploadedFile')
  end

  def existing_attachment?(document)
    document.is_a?(DocumentUploader) && document.file
  end

  def document_attached
    unless document_cache.present? || new_attachment?(document) || existing_attachment?(document)
      errors[:base] << 'a new version must have an attachment'
    end
  end

  def save!
    if delete == "1"
      model.destroy
    else
      super
    end
  end

end
