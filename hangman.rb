require_relative("board.rb")
require 'json'


def instructions
    puts `clear`
    puts "    ██   ██  █████  ███    ██  ██████  ███    ███  █████  ███    ██ 
    ██   ██ ██   ██ ████   ██ ██       ████  ████ ██   ██ ████   ██ 
    ███████ ███████ ██ ██  ██ ██   ███ ██ ████ ██ ███████ ██ ██  ██ 
    ██   ██ ██   ██ ██  ██ ██ ██    ██ ██  ██  ██ ██   ██ ██  ██ ██ 
    ██   ██ ██   ██ ██   ████  ██████  ██      ██ ██   ██ ██   ████ ";puts
    puts "Type start to start a new game"
    puts "     load to load from a previous save"
    puts "     exit to close this program!";puts
end

def menu
    instructions
    state = :on
    while state == :on
        case input = gets.chomp.downcase
        when "start"
            game(Board.new)
        when "load"
            saves = {}
            Dir.children("saves/").each_with_index {|name, i| saves[:"#{i}"] = name.gsub(".json", "")}
            puts `clear`
            puts "Please type the number of the save you wish to load!"
            puts "To delete a file enter delete";puts
            saves.each {|i, name| puts "#{i}: #{name}"}
            puts
            case input = gets.chomp.downcase
            when "delete"
                puts "Enter the number of the save you wish to delete"
                input = gets.chomp.downcase
                if File.exist?("saves/#{saves[:"#{input}"]}.json")
                    puts "Are you sure you wish to delete #{saves[:"#{input}"]}? y/n"
                    temp = input
                    input = gets.chomp.downcase
                    if input == "y"
                        File.delete("saves/#{saves[:"#{temp}"]}.json")
                        puts "#{saves[:"#{temp}"]} deleted!"
                    else
                        puts "Deletion cancelled"
                    end
                else
                    puts "#{input} is not a valid save selection!"
                end
            else
                if File.exist?("saves/#{saves[:"#{input}"]}.json")
                    unless load("saves/#{saves[:"#{input}"]}.json")
                        puts "Failed to load save!"
                    end
                else
                    puts "#{input} is not a valid save selection!"
                end
            end
        when "help"
        when "exit"
            state = :off
            puts; puts "Goodbye!"
        end
    end
end

def load(save)
    puts "Attempting to load #{save}"
    if File.exist?(save)
        translated_save = JSON.parse(File.read(save))
        game(Board.new(translated_save["turn"],translated_save["word"],translated_save["guesses"]))
        return true
    else
        return false
    end
end

def game(board)
    until board.state == :end
        board.print
        if board.turn == :end
            break
        end
    end
    puts "Press enter to continue back to menu!"
    gets
    instructions
end

menu()
