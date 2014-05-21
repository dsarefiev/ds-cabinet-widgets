class AddOrderDataToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :order_id, :string
    add_column :widgets, :target_url, :string
    add_column :widgets, :offerings, :text
  end
end
