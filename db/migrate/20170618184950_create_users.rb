class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :salaries do |t|
      t.string :telegram_id
      t.string :user_name

      t.timestamp
    end
  end
end
