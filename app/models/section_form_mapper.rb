class SectionFormMapper
  delegate_missing_to :section

  def initialize(section)
    @section = section
  end

  def versions
    section.versions.oldest_first
  end

  private

    attr_reader :section
end
