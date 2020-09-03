class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.references :user_id
      t.string :stripe_id, null: false
      t.string :address_zip, default: ""
      t.string :brand, null: false
      t.string :country, null: false
      t.string :last4, null: false
      t.string :funding, null: false
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
