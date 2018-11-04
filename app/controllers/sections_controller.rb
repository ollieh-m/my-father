class SectionsController < ApplicationController

  before_action :nav_setup

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