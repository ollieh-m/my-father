class Section::Index < Trailblazer::Operation
  def self.url_helpers
    Rails.application.routes.url_helpers
  end

  step :part
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find part with ID #{params[:part_id]}",
      go_to: url_helpers.admin_part_sections_path(part_id: Part.first),
      step: 'part'
    }
  }

  step :model

  step Contract::Build( constant: CreateSectionForm )

  step :sections

  def part(options, params:, **)
    options['part'] = Part.find_by(id: params[:part_id])
  end

  def model(options, params:, **)
    options['model'] = Section.new(part: options['part'])
  end

  def sections(options, params:, **)
    options['sections'] = options['part'].sections_by_position
  end
end
