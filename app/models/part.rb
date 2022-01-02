class Part < ApplicationRecord
  has_many :sections
  has_many :sections_by_position, -> { by_position }, class_name: 'Section'

  def self.pm_waiting_1970
    find_by(param: "pm_waiting_1970")
  end

  def self.scenes_1926_2002
    find_by(param: "scenes_1926_2002")
  end

  def self.ordered_for_nav
    order(
      Arel.sql(
        <<~SQL
          CASE 
            WHEN parts.param = 'pm_waiting_1970' THEN 0
            WHEN parts.param = 'scenes_1926_2002' THEN 1
          END
        SQL
      )
    )
  end

  def param
    super || title.parameterize
  end
end
