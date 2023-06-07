module Admin
  class LandingsController < BaseController
    def show
      redirect_to admin_part_sections_path(part_id: Part.first)
    end
  end
end
