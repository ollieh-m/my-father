class EditSectionForm < Reform::Form

  property :title
  collection :versions do

  end

  validation do
    required(:title).filled
  end

end
