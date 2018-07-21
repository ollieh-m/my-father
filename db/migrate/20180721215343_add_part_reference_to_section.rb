class AddPartReferenceToSection < ActiveRecord::Migration[5.1]
  def change
    add_reference :sections, :part, index: true, foreign_key: true
  end
end
