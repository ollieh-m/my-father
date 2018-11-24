class AddOrderToSection < ActiveRecord::Migration[5.1]
  def change
  	add_column :sections, :position, :integer
  end
end
