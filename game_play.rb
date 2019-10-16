require_relative "board.rb"
require_relative "tile.rb"
require "set"
require "yaml"
require "colorize"
require "byebug"


class GamePlay

    attr_accessor :board, :score

    def self.store_game(board)
        File.open("prev_board.yml", "w") { |file| file.write(board.to_yaml) }
    end

    def initialize(board)
        @board = board
        @score = 0
    end

    def play
        stepped_on_bomb = false 
        paused = false
        until stepped_on_bomb || won? || paused
            begin
                puts "Score: #{@score} HighestScore: #{@highest_score}"
                puts "Enter 'S' to save game state"
                render
                puts "Enter a pos from '0..8' such as '0,3'"
                pos = gets.chomp
                if pos == 'S' || pos == 's'
                    GamePlay.store_game(self.board)
                    system "clear"
                    puts "Your game state is Saved.. program has exited"
                    paused = true
                    return
                end
                stepped_on_bomb = make_move(pos.split(',').map(&:to_i))
                lost?(stepped_on_bomb) || won?
                self.score += 1
            rescue
                "Invalid entry, please try again."
                retry
            end
        end
    end

    def lost?(stepped_on_bomb)
        if stepped_on_bomb
            self.board.grid.flatten.each  do |card| 
                card.value = "dead" if card.value == 0 && card.is_flipped == true 
            end
            render
            self.score -= 1
            puts "Game Over!!!"
            File.delete("./prev_board.yml") if File.exist?("./prev_board.yml")
            true
        else
            false
        end
    end

    def won?
        if self.board.grid.flatten.all? { |card| card.value != "bomb" && card.is_flipped == true }
            render
            puts "You Won!!!"
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
                if card.is_flipped
                   Tile::VALUES[card.value]  
                else
                   Tile::VALUES["hidden"]
                end
            end
        end
        puts "  #{(0..8).to_a.join(" ")}"
        temp_grid.each_with_index { |row, idx| puts "#{idx} #{row.join(' ')}" }
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