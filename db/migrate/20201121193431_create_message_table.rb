class CreateMessageTable < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :sender, null: false
      t.references :recipient, null: false
      t.string :message
  
      t.timestamps
    end
  
    add_foreign_key :messages, :users, column: :sender_id, primary_key: :id
    add_foreign_key :messages, :users, column: :recipient_id, primary_key: :id
  end
end
