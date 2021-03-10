class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.string :title
      t.float :amount
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
