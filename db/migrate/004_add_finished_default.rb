class AddFinishedDefault < ActiveRecord::Migration
  def change
    change_column_default :todo_items, :finished, :false
  end
end
