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
  
  def addString(new_word)
    @root.addString(new_word, 0)
  end
  
  def include?(word)
    @root.include?(word, 0)
  end
  
  def printAllWords
    @root.printAllWords
  end
  
  def self.step_word_count
    @@word_count = @@word_count + 1
  end
  
  # The number of words in the whole tree
  def self.word_count
    @@word_count
  end
  
end

