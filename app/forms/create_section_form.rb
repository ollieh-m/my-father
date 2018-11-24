class CreateSectionForm < Reform::Form

  validates :title, presence: true

  property :title

  def save
  	begin
  		new_position = model.part.sections.new_position
  		model.position = new_position
  		super
  	rescue ::ActiveRecord::RecordNotUnique => e
  		save
  	end
  end

end
