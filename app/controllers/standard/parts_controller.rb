module Standard
  class PartsController < BaseController

    def show
      @current_page = Part.find_by(id: params[:id])

      render locals: {
        part: Part.find(params[:id])
      }
    end

  end
end