class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :client_id
      t.string :owner_id
      t.string :topic_id
      t.string :type
      t.string :status
      t.text   :metadata

      t.timestamps
    end
  end
end
