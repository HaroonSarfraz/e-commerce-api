class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|
      t.references :user
      t.string :city
      t.string :country
      t.string :line1
      t.string :line2
      t.string :state
      t.string :postal_code
      t.text :note
      t.boolean :active, default: true, null: false, index: true
      t.datetime :deleted_at, index: true
      t.string :first_name, default: "", null: false
      t.string :last_name, default: "", null: false
      t.string :phone_no, default: "", null: false

      t.timestamps
    end
  end
end
