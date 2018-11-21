class Section::Update < Trailblazer::Operation

  def self.url_helpers
    Rails.application.routes.url_helpers
  end

  step :model
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find section with ID #{params[:id]}",
      go_to: url_helpers.admin_part_sections_path(part_id: params[:part_id]),
      step: 'model'
    }
  }

  step Contract::Build( constant: EditSectionForm )

  step Contract::Validate( key: 'edit_section' )
  failure Macros::Failure::Set() { |options, params|
    {
      type: :now,
      step: 'contract.default.validate',
      go_to: :edit
    }
  }

  failure :prepopulate

  step Contract::Persist()

  def model(options, params:, **)
    if part = Part.find_by(id: params[:part_id])
      options['model'] = Section.find_by(id: params[:id], part: part)
    end
  end

  def prepopulate(options, params:, **)
    options['contract.default'].prepopulate! if options['contract.default']
  end

end
