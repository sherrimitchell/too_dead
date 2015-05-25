$LOAD_PATH.unshift(File.dirname(__FILE__))

require "too_dead/version"
require 'too_dead/init_db'
require 'too_dead/user'
require 'too_dead/todo_list'
require 'too_dead/todo_item'

require 'pry'
require 'vedeu'

module TooDead
  class Menu
    def initialize
      @user = nil
      @todo_list = nil
    end

    def prompt(question)
      puts "\n#{question}\n"
      input = gets.chomp
      until yield(input)
        puts "Sorry, I didn't understand that. #{question}\n"
        input = gets.chomp
      end
      input
    end

    def confirm?(message)
      choice = prompt("#{message} (y/n)") { |input| input == /^[yn]$/i }
      choice.upcase == 'Y'
    end

    def register
      name = prompt("What's your name?") { |input| input =~ /^\w+$/ }
      @user = User.find_or_create_by(name: name)
    end

    def unregister
      if confirm?("Are you sure you want to delete your account?")
        @user.destroy
        @user = nil
      end
    end

    def new_list
      message = "What would you like to call your Todo list?"
      name = prompt(message) { |input| input =~ /^\w+$/ }
      @todo_list = @user.todo_lists.create(name: name)
    end

    def delete_list
      if confirm?("Are you sure you want to delete #{@todo_list.name}?")
        @todo_list.destroy
        @todo_list = nil
      end
    end

    def pick_list
      @user.todo_lists.find_each do |l|
        puts "#{l.id} => #{l.name}"
      end
      choices_regex = /^#{@user.todo_lists.pluck(:id).join('|')}^/
      message = "Please pick one of the numbered Todo lists: "
      list_id = prompt(message) { |input| input =~ choices_regex }
      @todo_list = TodoList.find(list_id)
    end

    def run
    end
  end
end

# app = Menu.new
# app.run
