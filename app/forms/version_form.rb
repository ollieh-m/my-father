class VersionForm < Reform::Form

  property :id, writeable: false
  property :delete, virtual: true
  property :document
  property :document_cache

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
      document.attachment? ^ document_cache.attachment?
    end
  end

end
