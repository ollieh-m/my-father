class MakeSectionPositionUnique < ActiveRecord::Migration[5.1]
  def change
  	add_index :sections, [:position, :part_id], unique: true
  end
end
