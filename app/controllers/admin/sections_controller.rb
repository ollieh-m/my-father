module Admin
  class SectionsController < ApplicationController

    def index
      # test to check multiple forms in a view with the same inputs do not interfer
      @section_1 = Section.new
      @section_2 = Section.new
    end

    def create
      binding.pry
    end

  end
end
