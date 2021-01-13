require 'json'

class Board
    def initialize(turn = 0, word = choose_word, guesses = [])
        @gallow = ["               ██████████
                ██
                █
                █
                █
                █
               ███
            █████████████████","               ██████████
                ██      |
                █
                █
                █
                █
               ███
            █████████████████","               ██████████
                ██      |
                █       |
                █
                █
                █
               ███
            █████████████████","               ██████████
                ██      |
                █       |
                █      (_)
                █
                █
               ███
            █████████████████","               ██████████
                ██      |
                █       |
                █      (_)
                █      \\|/
                █
               ███
            █████████████████","               ██████████
                ██      |
                █       |
                █      (_)
                █      \\|/
                █       |
               ███
            █████████████████","               ██████████
                ██      |
                █       |
                █      (_)
                █      \\|/
                █       |
               ███     / \\
            █████████████████","               ██████████
                ██      |
                █       |
                █      (_)
                █      \\|/
                █       |
               ███     / \\
            ██████████     ██"]
        @turn = turn
        @word = word
        @guesses = guesses
        @hint_line = generate_hints
    end
    def choose_word
        filtered_words = []
        words = File.readlines("5desk.txt")
        words.each{|word| 
            if (5..12).cover? word.chomp.length
                filtered_words.push(word.chomp)
            end}
        random_word = filtered_words[rand(filtered_words.length)]
        return random_word.downcase
    end
    def print
        puts `clear`
        puts @gallow[@turn]
        puts; puts "            " + @hint_line.join(" "); puts
        puts "Your guesses so far.. #{@guesses.join(", ")}";puts
        puts "Type any letter to make a guess!"
        puts "     save to save your progress"
        puts "     exit to go back to menu";puts 
    end
    def generate_hints
        hint_line = []
        temp_word = @word.split("")
        temp_word.each_with_index{|letter, i| 
            if @guesses.include?(letter)
                hint_line.push(letter)
            else
                hint_line.push("_")
            end}
        return hint_line
    end
    def state
        if @turn >= 7
            print
            puts "Bad luck! The word was #{@word}."
            puts "Try again, or maybe you can rewind time somehow...";puts
            return :end
        end
        if @hint_line.include?("_")
            return true
        else
            print
            puts "Well done you did it!";puts
            return :end
        end
    end
    def save
        puts `clear`
        puts; puts "What would you like to call your save?";puts
        input = gets.chomp
        if input == ""
            input = "default"
        end
        puts "Creating new save..."
        save_hash = {
            turn: @turn,
            word: @word,
            guesses: @guesses
        }
        save_file = File.new("saves/#{input}.json", "w")
        save_file.puts(save_hash.to_json)
        save_file.close
        puts "#{input}.json made";puts 
        puts "Press enter to continue!"
        gets
        print
    end
    def turn
        state = :on
        while state == :on
            input = gets.chomp
            unless input == ""
                case input
                when "save"
                    save
                when "exit"
                    puts
                    return :end
                else
                    if @guesses.include?(input[0])
                        puts;puts "#{input[0]} has already been guessed!";puts
                    else
                        @guesses.push(input[0])
                        unless @word.include?(input[0])
                            @turn += 1
                        end
                        state = :off
                    end
                end
            end
        end
        @hint_line = generate_hints
    end
end