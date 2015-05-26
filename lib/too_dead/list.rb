module TooDead
  class List < ActiveRecord::Base
    has_many :items, :dependent => :destroy
    belongs_to :users, :dependent => :delete
  end
end