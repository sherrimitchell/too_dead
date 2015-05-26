$LOAD_PATH.unshift(File.dirname(__FILE__))

require "too_dead/version"
require 'too_dead/init_db'
require 'too_dead/user'
require 'too_dead/list'
require 'too_dead/item'

require 'pry'
require 'vedeu'

module TooDead
  class Menu
    # include Vedeu
    def initialize 
      @current_user = nil
      @todo_list = nil
      @todo_item = nil
    end
binding.pry
    def log_in
      puts "Please enter your name to login:"
      name = gets.chomp
      until name =~ /^\w+$/
        puts "Please enter a name: "
        name = gets.chomp
      end
      @current_user = User.find_by(name: name)
      if @current_user == nil 
        puts "Sorry, we were unable to find an account for you. If you would like to create one, please enter your name."
        name = gets.chomp
        until name =~ /^\w+$/
        puts "Please enter a name: "
        name = gets.chomp
        end
        @current_user = User.create_by(name: name)
      end
        puts "Welcome to Task Master, your virtual task buddy."
    end

    def delete_user?
      if @curent_user.log_in = false
        puts "Please login to delete your account."
        @current_user.log_in
        self.delete_user
        else
          puts """Would you like to Delete your account?
          Press 'Y' to continue:"""
          result = gets.chomp
        end
        @current_user = User.find_by(name: name).destroy
        end
    end

    def edit_todo_list
      if @curent_user.log_in = false
        puts "Please login to select a To Do List."
        @current_user.log_in
        q == self.quit?
        else
          puts "Please enter 1 to edit an existing list, 2 to create a new list, or q to quit:"
          result = gets.chomp
          
        end
      if result.to_i == 1
          @todo_list = @List.find_by(list_name: list_hame)
          puts "Please enter the Name of the list that you would like to edit:"
        elsif 
          @current_user.create_todo_list  
        else
          '#{q}'
        end
        @todo_list = @current_user.find(result)
        @current_user.edit_item
        end
        
    def create_todo_list
      if @curent_user.log_in = false
        puts "Please login to select a To Do List."
        @current_user.log_in
      else
        puts "Please enter a Name for your new list:"
        @todo_list = @List.create_by(list_name: list_name)
        result = gets.chomp
      end
      @todo_list = @current_user.create(result)
      @current_user.create_item
    end

    def delete_list?
      if !log_in
        puts "Please login to delete your list."
        @current_user.log_in
        else
        puts """Would you like to Delete your list?
        Press 'Y' to delete your list or 'X' to continue:"""
        result = gets.chomp
      end
      until result =~ /^[yx]$/
        puts "Press 'Y' to delete your account or 'X' to continue:"
        result = gets.chomp
      end
      if result.downcase == 'x'
          exit
        else result.downcase == 'y'
          @todo_list = List.find_by(list_name: list_name).destroy
        end
    end

   def create_item
      puts "You can add an item to your list by entering a name for the item. You can also enter an optional due date. Enter C to continue and enter your items. Enter D when you are done."
      result = gets.chomp
      until result.downcase == 'd'
      @todo_item = @Item.create_by(item_name: item_name, due_date: input)
      end
      result = @todo_item
    end
binding.pry
    def edit_items
      @list = list
      @todo_item = item
      list_items = list.item.all
      puts "Please enter the name of the item that you would like to edit:"
      result = gets.chomp
      until result == 'q'
      self.item(item_name: item_name, due_date: input)
      self.item_done?
    end

    def item_done?
      @list = list
      @todo_item = item
      list_items = list.item.all
      puts "Please enter Yes to mark an item as complete, or no to indicate that it is not complete:"
      result = gets.chomp
      self.item.update(completed: completed)
      list_done?
    end

    def quit?
      puts "Please press 'q' to quit: "
      result = gets.chomp
      if result.downcase == 'q'
          exit
        else
          self.edit_todo_list
        end
    end

    def list_done?
      self.edit_todo_list == quit?
      end

    def run
      welcome
      log_in
      while log_in
        delete_user?
        edit_todo_list
        create_todo_list
        delete_list?
        create_item
        edit_items
        item_done?
      end
      puts "Thanks for using Task Master!"
    end

    def welcome
      puts "\n\n"
      puts "Welcome to Task Master!"
      puts "\n\n"
    end
  end
end

binding.pry

# menu = TooDead::Menu.new
# menu.run
