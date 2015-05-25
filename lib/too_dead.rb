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

    def get_date(message)
      date_string = prompt("#{message} (YYYY-MM-DD format)") do |input|
        input =~ /^\d{4}-\d{2}-\d{2}$/
      end
      DateTime.parse(date_string)
    end

    def new_item
      name = prompt("What would you like to call your todo?") do |input|
        input =~ /^\w+$/
      end
      add_date = confirm?("Would you like to add a due date?")
      if add_date
        date = get_date("What date is #{name} due?")
      end
      @todo_list.create(description: name, due_date: date)
    end

    def change_date(todo)
      puts todo
      new_date = get_date("What is the new due date for #{todo.description}?")
      todo.update(due_date: new_date)
    end

    def toggle_completion(todo)
      todo.toggle!
      puts "#{todo} is now #{todo.finished? : 'done!' ? 'ready for work!' }"
    end

    def run
    end
  end
end

# app = Menu.new
# app.run
