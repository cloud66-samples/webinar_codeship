class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string  :kind
      t.string  :flavour
      t.integer :amount,  default: 0
      t.integer :status, default: 0
      t.boolean :done, default: false
      t.integer :amount_ready, default: 0
      t.timestamps
    end
  end
end
