
class Board

    attr_accessor :grid

    def self.fresh_board(grid)
        (0...grid.length).each { |idx_1| (0...grid.length).each { |idx_2| grid[idx_1][idx_2] = Tile.new(grid, [idx_1, idx_2]) } }
        row_arr = (0..8).to_a.shuffle
        col_arr = (0..8).to_a.shuffle
        9.times { grid[row_arr.shift][col_arr.shift].is_bomb = true }
        grid
    end


    def initialize(grid = nil)
        grid
        if grid
            @grid = grid
        else
            @grid = Board.fresh_board(Array.new(9) { Array.new(9, nil) })
            val_determiner
            card_neighbors
        end
    end


    def reveal(pos)
        card = self[pos]
        if card.value == 'bomb'
            game_over_flip(card)
            true
        else
            normal_flip_bfs(card)
            false
        end
    end

    def game_over_flip(card)
        card.is_flipped = true
        self.grid.flatten.each do |other_card|
            other_card.is_flipped = true if other_card.value == "bomb"
        end
    end

    def normal_flip_bfs(card)
        cards_checked_set = Set.new
        qu = [card.pos]
        until qu.empty?
            curr_card = self[qu.shift]
            if curr_card.value == 0
                curr_card.is_flipped = true
                qu += curr_card.neighbors
            elsif curr_card.value.is_a? Integer 
                curr_card.is_flipped = true 
            end
            qu.reject! { |card_pos| cards_checked_set.include?(card_pos) }
            cards_checked_set.add(curr_card.pos)
        end 
    end

    def val_determiner
        bomb_count = 0
        valid_num = (0..8).to_a
        self.grid.each_with_index do |row, idx_1|
            row.each_with_index do |ele, idx_2|
                card = self[[idx_1, idx_2]]
                Tile::SURROUNDING_POS.each do |pos|
                    a, b = pos
                    next if valid_num.none?(a + idx_1) || valid_num.none?(b + idx_2)
                    next if self[[(a + idx_1), (b + idx_2)]].nil? 
                    bomb_count += 1 if self[[(a + idx_1), (b + idx_2)]].is_bomb == true
                end
            card.is_bomb ? card.value = "bomb" : card.value = bomb_count
            bomb_count = 0
            end
        end
    end

    def card_neighbors
        self.grid.each do |row|
            row.each do |card|
                Tile::SURROUNDING_POS.each do |delta| 
                    valid_num = (0..8).to_a
                    a, b = delta
                    x, y = card.pos 
                    neighbor_pos = (a + x), (b + y)
                    next if valid_num.none?(a + x) || valid_num.none?(b + y)
                    card.neighbors << neighbor_pos
                end
            end
        end
    end

    def [](pos)
        x, y = pos
        self.grid[x][y]
    end

    def []=(pos, val)
        x, y = pos
        self.grid[x][y] = val
    end

    def inspect
        [@grid].inspect
    end
end