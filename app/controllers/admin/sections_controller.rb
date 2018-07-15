module Admin
  class SectionsController < ApplicationController

    def index
      @new_section = Section.new
    end

    def create
      binding.pry
    end

  end
end
