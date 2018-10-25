class Section::Show < Trailblazer::Operation

  step :version
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find version",
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
      step: 'version'
    }
  }

  step :sanitize

  def version(options, params:, **)
    if part = Part.find_by(id: params[:part_id])
      if section = Section.find_by(id: params[:id], part: part)
        options['version'] = section.versions.last
      end
    end
  end

  def read(options, params:, **)
    begin
      doc = Docx::Document.open(options['version'].document.file.file)
      options['text'] = doc.to_html
    rescue => e
      options['text.failure'] = e.message
    end
  end

  def sanitize(options, params:, **)
    options['text'] = options['text'].gsub('\n', '')
  end

end
