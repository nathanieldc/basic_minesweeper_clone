

class Board

    #put in tile class
        # '⚠️',
        # '💣',
        # '😵',
        # '😀',
        # '1️⃣',
        # '2️⃣',
        # '3️⃣',
        # '4️⃣',
        # '5️⃣',
        # '6️⃣',
        # '7️⃣',
        # '8️⃣'

        attr_accessor :board

    def self.fresh_board
        board = Array.new(9) { Array.new(9) {Tile.new} }
        row_arr = (0..8).to_a.shuffle
        col_arr = (0..8).to_a.shuffle
        9.times { board[row_arr.shift][col_arr.shift].is_bomb = true }
        board
    end

    def initialize(board = Board.fresh_board)
        @board = board
    end

end