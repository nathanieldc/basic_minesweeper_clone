require_relative "board.rb"
require_relative "tile.rb"
require_relative "cursor.rb"
require "set"
require "yaml"
require "io/console"
require "colorize"
require "byebug"


class GamePlay

    attr_accessor :board, :score, :pos

    def self.store_game(board)
        File.open("prev_board.yml", "w") { |file| file.write(board.to_yaml) }
    end

    def initialize(board)
        @board = board
        @score = 0
        @pos = nil
    end

    def play
        stepped_on_bomb = false 
        paused = false
        self.pos = [0,0]
        until stepped_on_bomb || won? || paused
            begin
                system "clear"
                puts "Score: #{@score}".colorize(:red)
                puts "Press 'Tab' to save the game state"
                render
                puts "Use arrow keys to select position, then hit Enter/Return"
                cursor_input = cursor_input?
                if cursor_input == 'TAB'
                    GamePlay.store_game(self.board)
                    system "clear"
                    puts "Your game state is Saved.. program has exited"
                    paused = true
                    return
                end
                stepped_on_bomb = make_move(self.pos) if cursor_input == "RETURN"
                lost?(stepped_on_bomb) || won?
                self.score += 1 if cursor_input == "RETURN"
            rescue
                "Invalid entry, please try again."
                retry
            end
        end
    end

    def cursor_input?
        case show_single_key
        when "UP ARROW"
            a, b = self.pos
            self.pos = a - 1, b
        when "DOWN ARROW"
            a, b = self.pos
            self.pos = a + 1, b
        when "LEFT ARROW"
            a, b = self.pos
            self.pos = a, b - 1
        when "RIGHT ARROW"
            a, b = self.pos
            self.pos = a, b + 1
        when "RETURN"
            return "RETURN"
        when "TAB"
            return "TAB"
        end
        false
    end

    def lost?(stepped_on_bomb)
        if stepped_on_bomb
            self.board.grid.flatten.each  do |card| 
                card.value = "dead" if card.value == 0 && card.is_flipped == true 
            end
            self.board[self.pos].value = "skull"
            self.pos = nil
            render
            puts "Game Over!!!".colorize(:red)
            File.delete("./prev_board.yml") if File.exist?("./prev_board.yml")
            true
        else
            false
        end
    end

    def won?
        if self.board.grid.flatten.all? { |card| card.value != "bomb" && card.is_flipped == true }
            self.pos = nil
            render
            puts "You Won!!!".colorize(:blue)
            File.delete("./prev_board.yml") if File.exist?("./prev_board.yml")
            true
        else    
            false
        end
    end

    def make_move(pos)
        board.reveal(pos)
    end

    def render
        temp_grid = self.board.grid.map do |row|
            row.map do |card|
                if card.pos == self.pos
                #    Tile::VALUES[card.value].colorize( :background => :red)
                   "😬"
                elsif card.is_flipped
                   Tile::VALUES[card.value]  
                else
                   Tile::VALUES["hidden"]
                end
            end
        end
        temp_grid.each { |row| puts "#{row.join(' ')}" }
    end

    def inspect
        [@board].inspect
    end

end

if __FILE__ == $PROGRAM_NAME
    if File.exist?("./prev_board.yml")
        board = YAML.load_file("prev_board.yml")
    else
        board = Board.new
    end
    game = GamePlay.new(board)
    game.play
end