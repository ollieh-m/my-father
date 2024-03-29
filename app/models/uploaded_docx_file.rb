class UploadedDocxFile
  include ActionView::Helpers::SanitizeHelper

  attr_reader :upload, :local_file

  def initialize(upload)
    @upload = upload
  end

  def to_html
    html = Docx::Document.open(local_file).to_html
    html = html.gsub('\n', "")
    sanitize(html, attributes: %w(href target))
  ensure
    close_file
  end

  private

    def local_file
      @_local_file ||= if upload.file.class.to_s == "CarrierWave::Storage::Fog::File"
                         URI.parse(upload.url).open
      else
        upload.file.file
      end
    end

    def close_file
      if local_file.is_a?(Tempfile)
        local_file.close && local_file.unlink
      end
    end
end
