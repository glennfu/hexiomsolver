require File.dirname(__FILE__) + "/hippy_node"

class HippyTree
  
  def initialize(options={})
    @root = HippyNode.new
    @@word_count = 0
  end
  
  def words=(new_words)
    new_words.each do |word|
      @root.addString(word, 0)
    end
  end
  
  def addBoard(board)
    Bencher.start 'add_tried'
    @root.addArray(board.flatten, 0)
    Bencher.stop 'add_tried'
  end
  
  def include?(board)
    Bencher.start 'flat'
    @@flat = board.flatten
    Bencher.stop 'flat'

    Bencher.start 'tried_include'
    answer = @root.include?(@@flat, 0)
    Bencher.stop 'tried_include'
    
    answer
  end
  
  def print_words
    @root.printAllWords
  end
  
  def self.step_word_count
    @@word_count = @@word_count + 1
  end
  
  # The number of words in the whole tree
  def word_count
    @@word_count
  end
  
end

