class Section::Show < Trailblazer::Operation
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
end