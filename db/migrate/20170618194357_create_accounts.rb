class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.float :remains
      t.string :name
      t.boolean :is_recurrent
      t.string :recurrent_time
      t.string :recurrent_name
      t.integer :user_id

      t.timestamp
    end
  end
end
