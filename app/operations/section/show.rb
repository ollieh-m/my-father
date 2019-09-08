class Section::Show < Trailblazer::Operation

  include ActionView::Helpers::SanitizeHelper

  step :version
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find a version",
      type: :now,
      go_to: :show,
      step: 'version'
    }
  }

  step :read
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not read version",
      detail: options['text.failure'],
      type: :now,
      go_to: :show,
      step: 'read'
    }
  }

  step :custom_sanitize

  def version(options, params:, **)
    if part = Part.find_by(id: params[:part_id])
      if section = Section.find_by(id: params[:id], part: part)
        options['version'] = section.versions.last
      end
    end
  end

  def read(options, params:, **)
    begin
      options['text'] = Rails.cache.fetch(options['version'].cache_key) do
        UploadedDocxFile.new(options['version'].document).to_html
      end
    rescue => e
      options['text.failure'] = e.message
      false
    end
  end

  def custom_sanitize(options, params:, **)
    without_newlines = options['text'].gsub('\n', '')
    options['text'] = sanitize(without_newlines, attributes: %w(href target))
  end
end