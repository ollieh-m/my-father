class CreateVersionModel < ActiveRecord::Migration[5.1]
  def change
    create_table :versions do |t|
      t.string :document
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
