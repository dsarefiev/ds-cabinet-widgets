class RenameClientSiebelIdColumnInWidgets < ActiveRecord::Migration
  def change
    rename_column :widgets, :client_siebel_id, :client_integration_id
  end
end
