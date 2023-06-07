module Standard
  class PartsController < BaseController
    def show
      @current_page = part

      render locals: {
        part:
      }
    end

    private

      def part
        @_part ||= Part.find(params[:id])
      end
  end
end
