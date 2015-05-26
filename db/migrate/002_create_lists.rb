class CreateLists < ActiveRecord::Migration
  def up
    create_table :lists do |t|
      t.string :list_name
    end
  end

  def down
    drop_table :lists
  end
end