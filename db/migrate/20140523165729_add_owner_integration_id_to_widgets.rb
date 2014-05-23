class AddOwnerIntegrationIdToWidgets < ActiveRecord::Migration
  def change
    add_column :widgets, :owner_integration_id, :string, after: :owner_id
  end
end
