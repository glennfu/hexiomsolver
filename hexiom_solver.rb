require File.dirname(__FILE__) + "/hippy_tree"
require File.dirname(__FILE__) + "/hippy_hash"

class HexiomSolver
  $transformations = [
    [0, -1], [1, 0], [1, 1], [0, 1], [-1, -1], [-1, 0]
  ]
  
  def initialize(options={})
    if options[:tree]
      @tried = HippyTree.new
    else
      @tried = HippyHash.new
    end
  end
  
  def tried_count
    @tried.word_count
  end
  
  def solved?(b)
    Bencher.start 'solved?'
    b.each_index do |row|
      b[row].each_index do |column|
        piece = b[row][column]
        return false if piece != NO_SPACE && piece != BLANK_SPACE && piece.abs != surrounding_pieces(b, row, column)
      end
    end
    Bencher.stop 'solved?'

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
  
  def find_solution2(b, current_tree, levels)
    
    if levels == 1
      if solved?(b)
        puts(values + current_tree)
      end
    end
    
    b.uniq.each do |v|
      t = current_tree.clone << v
      find_solution2(remove_value(b, v), t, levels-1)
    end
    
  end
  
  def remove_value(board, value)
    b = board.clone
    found = false

    b.delete_if { |x| 
      if !found && x == value
        found = true
        true
      else
        false
      end
    }

    b
  end

  def find_solution(b, valid_pieces)
  
    last_piece = nil
  
    valid_pieces.each_with_index do |p, index|
      # Don't use the same piece twice in a row
      if last_piece.nil?
        last_piece = p
      elsif last_piece == p
        next
      else
        last_piece = p
      end
    
      ranked_options(b, p).each do |x, y|
        b[x][y] = p

        unless @tried.include?(b)
          # Save this state since we haven't hit it already
          @tried.addBoard(b)

          # If we haven't come to a dead-end state
          if area_is_valid?(b, x, y)

            # Return if it's the answer!
            # First check to make sure we've used all the pieces
            return b if valid_pieces.length == 1 && solved?(b)

            # If not, remove the current piece
            new_pieces = valid_pieces.clone
            new_pieces.delete_at(index)

            # And send the remaining pieces on to the next recursion
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
    Bencher.start 'ranking'

    options = []

    # Find empty spaces
    b.each_index do |x|
      b[x].each_index do |y|
        space = b[x][y]
        if space == BLANK_SPACE
          if BoardLoader.potential_scores[x][y] >= p
            sp = surrounding_pieces(b, x, y)
            if sp <= p
              ss = surrounding_spaces(b, x, y)
              options << [x,y, ss, sp]
            end
          end
        end
      end
    end
      
      
    options.sort! do |e,f|
      # Find highest surrounding spaces
      comp = e[2] <=> f[2]
      # NOTE: The opposite order works better for level some levels
      # I need to figure out a smarter way to order these that work for all levels!
      
      
      if comp == 0
        # Then find highest score
        f[3] <=> e[3]
      else
        comp
      end
    end
    
    
    # # Find empty spaces
    # b.each_index do |x|
    #   b[x].each_index do |y|
    #     space = b[x][y]
    #     if space == BLANK_SPACE
    #       options << [x,y]
    #     end
    #   end
    # end
    #   
    #   
    # options.sort! do |e,f|
    #   # Find highest surrounding spaces
    #   comp = surrounding_spaces(b, f[0], f[1]) <=> surrounding_spaces(b, e[0], e[1])
    #   if comp == 0
    #     # Then find highest score
    #     surrounding_pieces(b, f[0], f[1]) <=> surrounding_pieces(b, e[0], e[1])
    #   else
    #     comp
    #   end
    # end
      
    Bencher.stop 'ranking'
  
    options
  end

  def area_is_valid?(b, row, column)
    Bencher.start 'area_is_valid'

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
  
    Bencher.stop 'area_is_valid'
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
      # TODO: Is this still needed with the potential_scores addition?
      if piece.abs > surrounding_pieces && not_surrounded_by_blank
        return false
      end
    
    end
  
    true
  end

  def print_words
    @tried.print_words
  end

end