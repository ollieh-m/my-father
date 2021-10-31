class Section::Create < Trailblazer::Operation
  step :part
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find part with ID #{params[:part_id]}",
      step: 'part'
    }
  }

  step :model

  step Contract::Build( constant: CreateSectionForm )

  step Contract::Validate( key: 'create_section' )
  failure Macros::Failure::Set() { |options, params|
    {step: 'contract.default.validate'}
  }

  step Contract::Persist()

  def part(options, params:, **)
    options['part'] = Part.find_by(id: params[:part_id])
  end

  def model(options, params:, **)
    options['model'] = Section.new(part: options['part'])
  end
end
