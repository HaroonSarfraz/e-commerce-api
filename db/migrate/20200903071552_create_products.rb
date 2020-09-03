class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :category
      t.string :name, null: false
      t.text :description
      t.string :image
      t.string :stripe_product_id

      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
