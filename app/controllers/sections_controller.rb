class SectionsController < ApplicationController

  before_action :nav_setup

  def index
    part = Part.find_by(id: params[:part_id])
    if part && first_section = part.sections.first
      redirect_to part_section_path(part_id: part, id: first_section)
    end
  end

  def show
    result = Section::Show.(params)

    if result.success?
      render locals: {
        text: result['text']
      }
    else
      handle_standard_failure(result['failure'], locals: {text: result['failure'].detail})
    end
  end

  private

  def nav_setup
    @parts = Part.all
  end

end