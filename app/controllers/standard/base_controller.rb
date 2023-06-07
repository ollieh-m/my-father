module Standard
  class BaseController < ApplicationController
    layout "standard"

    before_action :nav_setup

    private

      attr_reader :current_page
      helper_method :current_page

      def nav_setup
        @parts = Part.ordered_for_nav.includes(:sections_by_position)
      end
  end
end
