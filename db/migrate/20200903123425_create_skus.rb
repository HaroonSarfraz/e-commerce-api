class CreateSkus < ActiveRecord::Migration[5.2]
  def change
    create_table :skus do |t|
      t.references :product
      t.integer :inventory, default: 0, null: false
      t.monetize :price
      t.string :stripe_sku_id

      t.timestamps
    end
  end
end
