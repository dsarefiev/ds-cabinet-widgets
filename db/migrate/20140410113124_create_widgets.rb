class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :client_id
      t.string  :client_siebel_id
      t.integer :owner_id
      t.integer :topic_id
      t.string  :type
      t.string  :status
      t.text    :metadata

      t.timestamps
    end
  end
end
