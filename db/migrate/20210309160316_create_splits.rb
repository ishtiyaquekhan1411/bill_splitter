class CreateSplits < ActiveRecord::Migration[6.1]
  def change
    create_table :splits do |t|
      t.references :recipient, null: true, foreign_key: { to_table: :users }
      t.float :amount
      t.references :bill, null: false, foreign_key: true
      t.string :member_type
      t.timestamps
    end
  end
end
