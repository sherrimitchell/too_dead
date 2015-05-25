module TooDead
  class User < ActiveRecord::Base
    has_many :todo_lists
    ## The following association is reasonable but only necessary
    ## if we want to see or query all todo_items for a given user at once.
    # has_many :todo_items, through: :todo_lists
  end
end
