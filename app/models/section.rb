class Section < ApplicationRecord
  belongs_to :part
  has_many :versions

  def self.new_position
  	(maximum('position') || 0) + 1
  end
end
