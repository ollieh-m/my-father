class VersionForm < Reform::Form

  validate :document_attached
  validates :document, file_content_type: {
    allow: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
    mode: :strict, 
    unless: :document_blank,
    message: 'only .docx files are allowed'
  }

  property :id, writeable: false
  property :delete, virtual: true
  property :document, skip_if: :marked_for_deletion
  property :document_cache, skip_if: :marked_for_deletion

  def document_blank
    document.blank?
  end

  # this method is used in the recursive validation of nested forms
  # we tap into it to set document_cache in case of re-render
  # if there is a new attachment
  def validate!(errors, prefix)
    return_value = super
    if new_attachment? 
      if self.errors[:document].empty?
        self.document_cache = Version.new(document: document).document_cache
      else
        self.document_cache = nil
      end
    end
    return_value
  end

  def marked_for_deletion(fragment, *)
    fragment["delete"] == "1"
  end

  def document_cache_name
    document_cache.split('/').last if document_cache
  end

  def new_attachment?
    document.class.to_s.include?('UploadedFile')
  end

  def existing_attachment?
    document.is_a?(DocumentUploader) && document.file
  end

  def document_attached
    unless document_cache.present? || new_attachment? || existing_attachment?
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
