require File.dirname(__FILE__) + "/hippy_node"

class HippyTree
  
  def initialize(options={})
    if USE_TREE
      @root = HippyNode.new
      @@word_count = 0
    else
      @@tried_solutions = {}
    end
  end
  
  def words=(new_words)
    new_words.each do |word|
      @root.addString(word, 0)
    end
  end
  
  def addBoard(board)
    if USE_TREE
      @root.addArray(board.flatten, 0)
    else
      @@tried_solutions[@@flat] = true
    end
  end
  
  def include?(board)
    if USE_TREE
      Bencher.start 'flat'
      @@flat = board.flatten
      Bencher.stop 'flat'

      Bencher.start 'tried_include'
      answer = @root.include?(@@flat, 0)
      Bencher.stop 'tried_include'
    else
      Bencher.start 'flat'
      @@flat = board.collect{|row| row.collect{|val| val.nil? ? BLANK_SPACE : val}.join}.join
      Bencher.stop 'flat'

      Bencher.start 'tried_include'
      answer = @@tried_solutions[@@flat]
      Bencher.stop 'tried_include'
    end
    
    answer
  end
  
  def printAllWords
    @root.printAllWords
  end
  
  def self.step_word_count
    if USE_TREE
      @@word_count = @@word_count + 1
    end
  end
  
  # The number of words in the whole tree
  def self.word_count
    if USE_TREE
      @@word_count
    else
      @@tried_solutions.length
    end
  end
  
end

