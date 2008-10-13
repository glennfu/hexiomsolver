class Array
  def print
    self.each do |row|
      puts row.collect { |r| 
        if r == BLANK_SPACE
          " _"
        elsif r == NO_SPACE
          " x"
        elsif r < 0
          r
        else
          " #{r}"
        end
      }.join
    end
  end
end

class BoardLoader

  def self.load_from_string(string)
    lines = string.strip!.split("\n")

    board = []

    dim = lines.length
    lines.each_with_index do |line, index|
      line.strip!

      if index < dim/2
        (dim/2 - index).times do |i|
          line = line + " 9"
        end
      end

      if index > dim/2
        (index - dim/2).times do |i|
          line = "9 " + line
        end
      end

      board << line.split(" ").collect(&:to_i)
    end

    board
  end
  
  
  # build blank board
  def self.empty_board
    result = []
  
    @@board.each do |row|
      result << row.collect { |x| 
        if x == NO_SPACE 
          NO_SPACE
        elsif x < 0
          -x
        else
          BLANK_SPACE
        end
      }
    end
  
    result
  end
  
  def current_board
    @@board
  end
  
  def self.load(level)
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

    the_board[5] = %Q{
      8, 8, -1
      2, 8, 8, 8
      8, 8, 1, 8, 8
      8, 8, 8, 2
      -2, 8, 8
    }

    the_board[6] = %Q{
      2 8 2
      2 8 8 8
      2 2 9 8 2
      -1 9 8 2
      9 -1 8
    }

    the_board[11] = %Q{
      2 8 2
      8 1 1 8
      -2 9 9 9 -2
      8 1 1 8
      2 8 2
    }

    the_board[15] = %Q{
      2 8 2
      8 2 2 4
      3 8 2 8 8
      3 8 8 2
      3 8 3
    }

    the_board[18] = %Q{
      -3 4 3
      8 4 8 5
      3 1 9 8 4
      2 9 3 2
      9 3 -3
    }

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

    the_board[31] = %Q{
      3 8 5
      3 3 8 3
      3 4 8 3 2
      5 3 8 2
      4 5 8
    }

    the_board["rand4"] = %Q{
      5 2 9 8
      3 1 3 3 2
      9 9 5 9 1 2
      9 2 9 9 2 2 1
      4 9 3 8 3 3
      2 8 2 9 9
      1 8 3 3
    }

    the_board[36] = %Q{
      3 3 3 3
      3 4 8 3 3
      3 8 1 8 8 2
      3 4 8 8 2 1 8
      4 4 2 2 8 2
      3 8 8 8 2
      2 2 2 2
    }
    
    begin
      if the_board[level].is_a?(String)
        @@board = load_from_string the_board[level]
      else
        @@board = the_board[level]
      end
    
      $width = @@board[0].size
      $height = @@board.size
    
      @@board
    rescue
      raise "Could not load board #{level}"
    end
  end
end