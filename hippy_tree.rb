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
  
  def addString(new_word)
    if USE_TREE
      @root.addString(new_word, 0)
    else
      @@tried_solutions[new_word] = true
    end
  end
  
  def include?(word)
    if USE_TREE
      @root.include?(word, 0)
    else
      @@tried_solutions[word]
    end
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

