class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.references :order_id
      t.references :product_id
      t.integer :cost_cents, default: 0, null: false
      t.string :cost_currency, default: "USD", null: false
      t.integer :quantity

      t.timestamps
    end
  end
end
