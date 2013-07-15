class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :price
      t.integer :aisle_id

      t.timestamps
    end
  end
end
