module TooDead
  class TodoItem < ActiveRecord::Base
    belongs_to :todo_list

    def toggle!
      self.update(finished: !self.finished)
    end
  end
end
