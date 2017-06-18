class CreateCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :costs do |t|
      t.string :title
      t.float :expense
      t.integer :account_id

      t.timestamp
    end
  end
end
