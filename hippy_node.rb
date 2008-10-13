class HippyNode
  
  attr_accessor :character, :parent
  
  def initialize(options={})
    @character = options[:character]
    @parent = options[:parent]
  end
  
  def root?
    @parent.nil?
  end
  
  def word?
    @isWord
  end
  
  def addArray(array, start)
    if start == array.length
      
      unless @isWord
        HippyTree.step_word_count
        @isWord = true
      end
      
    else
      
      index = array[start]
      @children ||= []
      @children[index] ||= HippyNode.new(:character => index, :parent => self)
      @children[index].addArray(array, start + 1)
      
    end
  end
  
  def addString(string, start)
    if start == string.length
      
      unless @isWord
        HippyTree.step_word_count
        @isWord = true
      end

    else
    
      char = string[start, 1]
      index = char.to_i
      @children ||= []
      @children[index] ||= HippyNode.new(:character => char, :parent => self)
      @children[index].addString(string, start + 1)

    end
  end
  
  def printWord
    word = ""
    
    h = @parent
    while !h.root?
      word << h.character
      h = h.parent
    end
    
    word
  end
  
  def printAllWords
    if word?
      printWord
    end
    
    @children.each do |child|
      child.printAllWords
    end
  end
  
  def include?(board, start)
    return word? if start == board.length
    
    return false if @children.nil?
    
    child = @children[board[start]]
    if child
      child.include?(board, start + 1)
    else
      false
    end
  end
  
end