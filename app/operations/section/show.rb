class Section::Show < Trailblazer::Operation
  step :section
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find the section",
      type: :now,
      go_to: :show,
      step: "section"
    }
  }

  step :version
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find a version",
      type: :now,
      go_to: :show,
      step: "version"
    }
  }

  step :read
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not read version",
      detail: options["text.failure"],
      type: :now,
      go_to: :show,
      step: "read"
    }
  }

  def section(options, params:, **)
    if part = Part.find_by(id: params[:part_id])
      options["section"] = Section.find_by(id: params[:id], part:)
    end
  end

  def version(options, params:, **)
    options["version"] = options["section"].versions.oldest_first.last
  end

  def read(options, params:, **)
    begin
      options["text"] = Rails.cache.fetch(options["version"].cache_key) do
        UploadedDocxFile.new(options["version"].document).to_html
      end
    rescue => e
      options["text.failure"] = e.message
      false
    end
  end
end
