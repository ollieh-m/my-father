class CreateSectionForm < Reform::Form

  property :title

  validation do
    required(:title).filled
  end

end
