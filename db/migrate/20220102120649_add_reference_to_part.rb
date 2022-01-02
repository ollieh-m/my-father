class AddReferenceToPart < ActiveRecord::Migration[5.2]
  def change
    add_column :parts, :param, :string

    add_index :parts, :param
  end
end
