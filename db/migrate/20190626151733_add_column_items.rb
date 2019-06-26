class AddColumnItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :discounted_price, :decimal, null: true
    add_column :items, :last_discounted_price, :decimal, null: true
    add_column :items, :discount_limit_given, :boolean, default: false
  end
end
