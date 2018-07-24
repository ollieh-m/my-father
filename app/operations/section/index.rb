class Section::Index < Trailblazer::Operation

  step :part
  # TO DO: redirect to first part, whatever it is
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find part with ID #{params[:part_id]}",
      type: :next,
      go_to: '/admin/parts/1/sections'
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
