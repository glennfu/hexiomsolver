class HexiomSolver
  $transformations = [
    [0, -1], [1, 0], [1, 1], [0, 1], [-1, -1], [-1, 0]
  ]
  
  def initialize(options={})
    @tried = HippyTree.new
  end
  
  def solved?(b)
    b.each_index do |row|
      b[row].each_index do |column|
        piece = b[row][column]
        return false if piece != NO_SPACE && piece != BLANK_SPACE && piece.abs != surrounding_pieces(b, row, column)
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
        if (val != NO_SPACE) && (val != BLANK_SPACE)
          pieces = pieces + 1
        end
      end
    end

    pieces
  end

  def surrounding_spaces(b, x, y)
    spaces = 0
    $transformations.each do |transform|
      temp_x = x + transform[0]
      temp_y = y + transform[1]
    
      if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
        val = b[temp_x][temp_y]
        if (val == BLANK_SPACE)
          spaces = spaces + 1
        end
      end
    end

    spaces
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
    
      ranked_options(b, p).each do |x, y|
        b[x][y] = p
        
        tried_include = @tried.include?(b)
        
        Bencher.start 'area_is_valid'
        area_is_valid = area_is_valid?(b, x, y)
        Bencher.stop 'area_is_valid'
        
        
        if !tried_include
          # puts flat
          Bencher.start 'add_tried'
          @tried.addBoard(b)
          Bencher.stop 'add_tried'
          
          if area_is_valid
        
            if valid_pieces.length == 1
            
              Bencher.start 'solved?'
              solved = solved?(b)
              Bencher.stop 'solved?'
            
              return b if solved
            end

            new_pieces = valid_pieces.clone
            new_pieces.delete_at(index)

            answer = find_solution(b, new_pieces)
            return answer if answer
          end
        end
        
        b[x][y] = BLANK_SPACE
      end
    
    end
  
  
    nil
  end

  def ranked_options(b, p) #.each do |x, y|

    options = []

    # Find empty spaces
    b.each_index do |x|
      b[x].each_index do |y|
        space = b[x][y]
        if space == BLANK_SPACE
          options << [x,y]
        end
      end
    end
  
  
    options.sort! do |e,f|
      # Find highest surrounding spaces
      comp = surrounding_spaces(b, f[0], f[1]) <=> surrounding_spaces(b, e[0], e[1])
      if comp == 0
        # Then find highest score
        surrounding_pieces(b, f[0], f[1]) <=> surrounding_pieces(b, e[0], e[1])
      else
        comp
      end
    end
  
    # puts "p: #{p}"
    # puts surrounding_spaces(b, options.first[0], options.first[1])
  
    options
  end

  def area_is_valid?(b, row, column)
    Bencher.start 'is_valid?'
    valid = is_valid?(b, row, column)
    Bencher.stop 'is_valid?'

    return false unless valid
    
    $transformations.each do |transform|
      temp_x = row + transform[0]
      temp_y = column + transform[1]
    
      if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
        return false unless is_valid?(b, temp_x, temp_y)
      end
    end
  
    true
  end

  def is_valid?(b, row, column)
    piece = b[row][column]
    if piece != NO_SPACE && piece != BLANK_SPACE

      surrounding_pieces = 0
      not_surrounded_by_blank = true
    
      $transformations.each do |transform|
        temp_x = row + transform[0]
        temp_y = column + transform[1]

        if (temp_x >= 0 && temp_x < $width) && (temp_y >= 0 && temp_y < $height)
          new_piece = b[temp_x][temp_y]
          if new_piece == BLANK_SPACE
            not_surrounded_by_blank = false
          else
            if (new_piece != NO_SPACE)
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
      if piece.abs > surrounding_pieces && not_surrounded_by_blank
        return false
      end
    
    end
  
    true
  end



end