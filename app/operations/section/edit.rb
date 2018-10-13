class Section::Edit < Trailblazer::Operation

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

  step :prepopulate

  def model(options, params:, **)
    if part = Part.find_by(id: params[:part_id])
      options['model'] = Section.find_by(id: params[:id], part: part)
    end
  end

  def prepopulate(options, params:, **)
    options['contract.default'].prepopulate!
  end

end
