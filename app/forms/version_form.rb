class VersionForm < Reform::Form

  property :id, writeable: false
  property :delete, virtual: true
  property :document
  property :document_cache

  validation do
    configure do
      def attachment?(document)
        # check if submitted document is an actual attachment
        # when no file is attached document is DocumentUploader:0x007fcd9d3636d0
        # when there is a file attached document is ActionDispatch::Http::UploadedFile:0x007fcd95bcd508
        # also needs to work with document_cache
        binding.pry
        document && !!document.file
      end
    end

    required(:document).maybe
    required(:document_cache).maybe
    rule(document_attached: [:document, :document_cache]) do |document, document_cache|
      document.attachment? ^ document_cache.attachment?
    end
  end

end
