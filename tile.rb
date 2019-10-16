

class Tile

    SURROUNDING_POS = [
        [-1, -1],
        [-1, 0],
        [-1, 1],
        [0, -1],
        [0, 1],
        [1, -1],
        [1, 0],
        [1, 1]
    ]

    VALUES = {
        "skull" => '💀',
        "flag" => '⚠️',
        "bomb" => '💣',
        "dead" => '😵',
        0 => '😀',
        "pet" => '🐕',
        "pet_dead" => '🦴',
        "hidden" => '🔲',
        1 => '1️⃣',
        2 => '2️⃣',
        3 => '3️⃣',
        4 => '4️⃣',
        5 => '5️⃣',
        6 => '6️⃣',
        7 => '7️⃣',
        8 => '8️⃣'
    }

    attr_accessor :board, :is_bomb, :is_flipped, :value, :neighbors, :pos

    def initialize(board, pos)
        @board = board
        @is_bomb = false
        @is_flipped = false
        @value = nil
        @neighbors = []
        @pos = pos
    end

    def inspect 
        [ @board, 
        @is_bomb, 
        @is_flipped, 
        @value, 
        @neighbors, 
        @pos ].inspect
    end

end