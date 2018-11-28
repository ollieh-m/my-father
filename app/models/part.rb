class Part < ApplicationRecord
  has_many :sections
  has_many :sections_by_position, -> { by_position }, class_name: 'Section'
end
