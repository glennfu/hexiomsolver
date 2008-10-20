require File.dirname(__FILE__) + "/hippy_node"

class HippyHash

  def initialize(options={})
    @tried_solutions = {}
  end

  def addBoard(board)
    @tried_solutions[@flat] = true
  end

  def include?(board)
    Bencher.start 'flat'
    @flat = board.collect{|row| row.collect{|val| val.nil? ? BLANK_SPACE : val}.join}.join
    Bencher.stop 'flat'

    Bencher.start 'tried_include'
    answer = @tried_solutions[@flat]
    Bencher.stop 'tried_include'

    answer
  end

  # The number of words in the whole tree
  def word_count
    @tried_solutions.length
  end
  
  def print_words
    puts @tried_solutions.keys.collect.join("\n")
  end
  
end