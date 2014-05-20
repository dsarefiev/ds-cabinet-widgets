class AddProductsToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :products, :string
  end
end
