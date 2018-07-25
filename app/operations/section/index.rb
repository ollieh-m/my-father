class Section::Index < Trailblazer::Operation


  # TO DO: redirect to first part, whatever it is, on failure using path helper:
  # admin_part_sections_path(part_id: Part.first)
  step :part
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find part with ID #{params[:part_id]}",
      go_to: "/admin/parts/#{Part.first.id}/sections",
      step: 'part'
    }
  }

  step :model

  step Contract::Build( constant: CreateSectionForm )

  def part(options, params:, **)
    options['part'] = Part.find_by(id: params[:part_id])
  end

  def model(options, params:, **)
    options['model'] = Section.new(part: options['part'])
  end

end
