class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :state, default: 0, null: false, index: true
      t.references :user_id
      t.datetime :delivered_at
      t.references :shipping_address
      t.string :stripe_order_id
      t.references :card

      t.monetize :total_amount
      t.monetize :total_items_costs

      t.timestamps
    end
  end
end
