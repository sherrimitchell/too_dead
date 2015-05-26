class CreateItems < ActiveRecord::Migration
  def up
    create_table :items do |t|
      t.string :item_name
      t.datetime :due_date
      t.boolean :completed
      t.timestamps null: false
    end
  end

  def down
    drop_table :items
  end
end