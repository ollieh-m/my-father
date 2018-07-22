class Section::Create < Trailblazer::Operation

  step :get_part
  step :model
  step Contract::Build( constant: CreateSectionForm )
  step Contract::Validate( key: 'section' )
  step Contract::Persist()

  def get_part(options, params:, **)
    options['part'] = Part.find_by(params[:part_id])
  end

  def model(options, params:, **)
    options['model'] = Section.new(part: options['part'])
  end

end
