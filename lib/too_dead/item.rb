module TooDead
  class Item < ActiveRecord::Base
    belongs_to :lists, :dependent => :delete
  end
end
