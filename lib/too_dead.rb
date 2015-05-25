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
      @show_overdue = false
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
      choices_regex = /^#{@user.todo_lists.pluck(:id).join('|')}$/
      message = "Please pick one of the numbered Todo lists: "
      list_id = prompt(message) { |input| input =~ choices_regex }
      @todo_list = TodoList.find(list_id)
    end

    def pick_item
      items = @todo_list.todo_items.where(finished: false)
      items = items.where("due_date < ?", DateTime.now) if @show_overdue
      items.find_each do |item|
        puts "#{item.id} => #{l.description}"
      end
      choices_regex = /^#{items.pluck(:id).join('|')}$/
      message = "Please pick one of the numbered Todo items: "
      todo_id = prompt(message) { |input| input =~ choices_regex }
      TodoItem.find(todo_id)
    end

    def work_on_list
      puts @todo_list
      message = "\n\nPlease choose one of the following options:
                   B) Go Back and pick a different Todo list.
                   O) Toggle display of Overdue/regular todos.

                   N) Create a new todo.
                   D) Change a todo's due date.
                   R) Remove a todo.
                   F) Mark a todo as finished or unfinished.\n\n"
      choice = prompt(message) { |input| input =~ /^[bondrf]$/i }.downcase
      case choice
      when 'b'
        @todo_list = nil
      when 'o'
        @show_overdue = !@show_overdue
      when 'n'
        new_item
      when 'd'
        change_date(pick_todo)
      when 'r'
        remove_todo(pick_todo)
      when 'f'
        toggle_completion(pick_todo)
      end
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
