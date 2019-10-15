require_relative "board.rb"
require_relative "tile.rb"
require "set"
require "byebug"

class GamePlay

    attr_reader :board

    def initialize(board)
        @board = board
    end

    def play
        render
        game_over = false 
        until game_over
            puts "Enter a pos from '0..8' such as '0, 3'"
            pos = gets.chomp.split(',').map(&:to_i)
            game_over = make_move(pos)
            render
        end
        puts "Game Over"
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
    board = Board.new
    game = GamePlay.new(board)
    game.play
end