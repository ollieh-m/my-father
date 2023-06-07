module Standard
  class LandingsController < BaseController
    def show
      @current_page = :landing
    end
  end
end
