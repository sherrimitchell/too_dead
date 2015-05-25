class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.integer  :todo_list_id
      t.string   :description
      t.datetime :due_date
      t.boolean  :finished
    end
  end
end
