class VersionForm < Reform::Form

  property :id, writeable: false
  property :delete, virtual: true
  property :document
  property :document_cache

  def deserialize!(input)
    # set document_cache in case of re-render
    input['document_cache'] = Version.new(document: input['document']).document_cache if new_attachment?(input['document'])
    super(input)
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

  validation :default do
    configure do
      config.messages_file = 'config/locales/error_messages.yml'

      def attachment?(document)
        # check if submitted document is an actual attachment
        # when no new file is attached, 'document' is DocumentUploader
        # when there is a new file attached, 'document' is ActionDispatch::Http::UploadedFile
        if document
          # new_attachment?
          return true if document.class.to_s.include?('UploadedFile')
          # existing_attachment?
          return true if document.is_a?(DocumentUploader) && document.file
        end
      end
    end

    required(:document).maybe
    required(:document_cache).maybe
    rule(document_attached: [:document, :document_cache]) do |document, document_cache|
      document_cache.filled? | document.attachment?
    end
    # TO DO: validate that any attachment is a text or doc file
  end

end
