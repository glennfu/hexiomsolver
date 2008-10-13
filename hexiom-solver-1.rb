
NO_SPACE = 9
BLANK_SPACE = 8
$tried_solutions = {}
$transformations = [
  [0, -1], [1, 0], [1, 1], [0, 1], [-1, -1], [-1, 0]
]

the_board = {}

# level 2
the_board[2] = [
  [8, 1, 9],
  [8, 1, 1],
  [9, 1, 8]
]

# level 3
the_board[3] = [
  [2, 8, 2, 9, 9],
  [8, 2, 2, 8, 9],
  [2, 2, 8, 2, 2],
  [9, 8, 2, 2, 8],
  [9, 9, 2, 8, 2]
]

the_board[4] = [
  [3, 8, 3, 9, 9],
  [8, 8, 8, 8, 9],
  [3, 8,-6, 8, 3],
  [9, 8, 8, 8, 8],
  [9, 9, 3, 8, 3]
]

# level 26
the_board[26] = [
  [1, 2, 9, 9, 9],
  [2, 2, 2, 8, 9],
  [4, 4, 8, 1, 3],
  [9, 4, 3, 8, 4],
  [9, 9, 9, 4, 8]
]

# level 30
the_board[30] = [
  [8, 3, 3, 5, 9, 9, 9],
  [4, 3, 8, 8, 5, 9, 9],
  [5, 5, 3, 2, 2, 8, 9],
  [4,-2, 4,-4, 8,-2, 8],
  [9, 8, 8, 8, 4, 5, 6],
  [9, 9, 8, 8, 5, 8, 8],
  [9, 9, 9, 8, 3, 4, 3]
]

solution = [
  [1, 2, 9, 9, 9],
  [8, 8, 4, 3, 9],
  [2, 4, 4, 4, 2],
  [9, 3, 4, 8, 8],
  [9, 9, 9, 2, 1]
]

$benchmarks = {}
def bench(key, time)
  $benchmarks[key] = 0 unless $benchmarks.has_key?(key)
  $benchmarks[key] = $benchmarks[key] + time
end


# build blank board
def empty_board(board)
  result = []
  
  board.each do |row|
    result << row.collect { |x| 
      if x == NO_SPACE 
        NO_SPACE
      elsif x < 0
        x
      else
        nil
      end
    }
  end
  
  result
end

def solved?(b)
  b.each_index do |row|
    b[row].each_index do |column|
      piece = b[row][column]
      return false if !piece.nil? && piece != NO_SPACE && piece != BLANK_SPACE && piece.abs != surrounding_pieces(b, row, column)
    end
  end
  
  true
end

def surrounding_pieces(b, x, y)
  pieces = 0
  $transformations.each do |transform|
    temp_x = x + transform[0]
    temp_y = y + transform[1]
    
    if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
      val = b[temp_x][temp_y]
      if !val.nil? && (val != NO_SPACE) && (val != BLANK_SPACE)
        pieces = pieces + 1
      end
    end
  end

  pieces
end

def has_nil?(b)
  b.each do |row|
    return true if row.include?(nil)
  end
  false
end

def find_solution(b, valid_pieces)
  
  last_piece = nil
  
  valid_pieces.each_with_index do |p, index|
    if last_piece.nil?
      last_piece = p
    elsif last_piece == p
      next
    else
      last_piece = p
    end
    
    b.each_index do |x|
      b[x].each_index do |y|
        space = b[x][y]
        if space.nil?
          
          b[x][y] = p
          
          start_time = Time.now
          flat = b.join(".")
          bench('flat', Time.now - start_time)
          
          start_time = Time.now
          tried_include = $tried_solutions[flat]
          bench('tried_include', Time.now - start_time)
          
          start_time = Time.now
          area_is_valid = area_is_valid?(b, x, y)
          bench('area_is_valid', Time.now - start_time)
          
          if !tried_include && area_is_valid
            # unless has_nil?(b)
            if valid_pieces.length == 1
              
              start_time = Time.now
              solved = solved?(b)
              bench('solved?', Time.now - start_time)
              
              return b if solved
            end

            new_pieces = valid_pieces.clone
            new_pieces.delete_at(index)

            answer = find_solution(b, new_pieces)
            if answer
              return answer
            else
              $tried_solutions[flat] = true
              b[x][y] = nil
            end
            
          else
            b[x][y] = nil
          end
          
        end
      end
    end
    
  end
  
  
  nil
end

def area_is_valid?(b, row, column)

  start_time = Time.now
  valid = is_valid?(b, row, column)
  bench('is_valid?', Time.now - start_time)
  
  return false unless valid
  
  $transformations.each do |transform|
    temp_x = row + transform[0]
    temp_y = column + transform[1]
    
    if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
      start_time = Time.now
      valid = is_valid?(b, temp_x, temp_y)
      bench('is_valid?', Time.now - start_time)
      
      return false unless valid
    end
    
  end
  
end

def is_valid?(b, row, column)
  piece = b[row][column]
  if !piece.nil? && piece >=0 && piece != NO_SPACE && piece != BLANK_SPACE

    surrounding_pieces = 0
    not_surrounded_by_nil = true
    
    $transformations.each do |transform|
      temp_x = row + transform[0]
      temp_y = column + transform[1]

      if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
        new_piece = b[temp_x][temp_y]
        if new_piece.nil?
          not_surrounded_by_nil = false
        else
          if (new_piece != NO_SPACE) && (new_piece != BLANK_SPACE)
            surrounding_pieces = surrounding_pieces + 1
          end
        end
      end
    end
    
    # Surrounded by too many
    if piece.abs < surrounding_pieces
      return false
    end
    
    # Not surrounded by enough, and no room for more
    if piece.abs > surrounding_pieces && not_surrounded_by_nil
      return false
    end
    
  end
  
  true
end

def area_is_valid_old?(b)
  b.each_index do |row|
    b[row].each_index do |column|
      piece = b[row][column]
      if !piece.nil? && piece != NO_SPACE && piece != BLANK_SPACE

        surrounding_pieces = 0
        not_surrounded_by_nil = true
        
        $transformations.each do |transform|
          temp_x = row + transform[0]
          temp_y = column + transform[1]

          if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
            new_piece = b[temp_x][temp_y]
            if new_piece.nil?
              not_surrounded_by_nil = false
            else
              if (new_piece != NO_SPACE) && (new_piece != BLANK_SPACE)
                surrounding_pieces = surrounding_pieces + 1
              end
            end
          end
        end
        
        # Surrounded by too many
        if piece.abs < surrounding_pieces
          return false
        end
        
        # Not surrounded by enough, and no room for more
        if piece.abs > surrounding_pieces && not_surrounded_by_nil
          return false
        end
        
      end
    end
  end
  
  true
end

board = the_board[2]
$width = board[0].size
$height = board.size

# puts "sol: #{solution.inspect}"
# puts "sol valid? #{isValid?(solution)}"
# puts "sol solved? #{!has_nil?(solution)}"

empty_board = empty_board(board)
valid_pieces = board.flatten.reject{|x| (x == NO_SPACE || x < 0 || x == BLANK_SPACE) }.sort

start_time = Time.now
puts find_solution(empty_board, valid_pieces).inspect
puts "Took: #{(Time.now - start_time)}"
puts $benchmarks.inspect

# puts empty_board.inspect
# puts "---"
# puts valid_pieces.inspect
# puts "---"
# puts board.inspect
# puts "---"
# puts build_board(empty_board, valid_pieces).inspect

