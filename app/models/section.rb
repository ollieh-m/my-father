class Section < ApplicationRecord
  belongs_to :part
  has_many :versions
end
