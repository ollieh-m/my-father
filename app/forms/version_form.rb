class VersionForm < Reform::Form

  property :id, writeable: false
  property :delete, virtual: true
  property :document
  property :document_cache

  def deserialize!(input)
    # set document_cache in case of re-render
    input['document_cache'] = Version.new(document: input['document']).document_cache if input['document_cache'].blank?
    super(input)
  end

  def document_cache_name
    document_cache.split('/').last if document_cache
  end

  validation do
    configure do
      config.messages_file = 'config/locales/error_messages.yml'

      def attachment?(document)
        # check if submitted document is an actual attachment
        # when no new file is attached, 'document' is DocumentUploader
        # when there is a new file attached, 'document' is ActionDispatch::Http::UploadedFile
        if document
          return true if document.is_a?(DocumentUploader) && !!document.file
          return true if document.is_a?(ActionDispatch::Http::UploadedFile)
        end
      end
    end

    required(:document).maybe
    required(:document_cache).maybe
    rule(document_attached: [:document, :document_cache]) do |document, document_cache|
      document_cache.filled? | document.attachment?
    end
  end

end
