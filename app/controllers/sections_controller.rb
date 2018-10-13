class SectionsController < ApplicationController

  before_action :nav_setup

  def show
    # this demonstrates how we'll get the paragraphs from the document
    version = Section.find(params[:id]).versions.last
    doc = Docx::Document.open(version.document.file.file)
    doc.paragraphs.each do |p|
      puts p
    end
  end

  private

  def nav_setup
    @parts = Part.all
  end

end