class SectionOrder::Update < Trailblazer::Operation
  step :part
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Could not find part with ID #{params[:part_id]}",
      step: "part"
    }
  }

  step :sections

  step :validate_sections
  failure Macros::Failure::Set() { |options, params|
    {
      message: "Sections are invalid",
      step: "validate_sections"
    }
  }

  step :persist_order

  def part(options, params:, **)
    options["part"] = Part.find_by(id: params[:part_id])
  end

  def sections(options, params:, **)
    options["sections"] = params[:ordered_sections].reject(&:blank?).map do |section|
      id = /section_(\d+)/.match(section)[1]
      options["part"].sections.find_by(id:)
    end.uniq
  end

  def validate_sections(options, params:, **)
    return false if options["sections"].any?(&:nil?)
    return false if options["part"].sections.where.not(id: options["sections"].map(&:id)).any?
    true
  end

  def persist_order(options, params:, **)
    ActiveRecord::Base.transaction do
      options["sections"].each_with_index do |section, index|
        position = index + 1
        current_section = options["part"].sections.find_by(position:)
        if current_section && current_section != section
          # reset section that currently has the given position, to prevent temporary duplicate
          # when we set the new position on this section
          current_section.update_column(:position, nil) if current_section && current_section != section
        end
        section.update_column(:position, position)
      end
    end
  end
end
