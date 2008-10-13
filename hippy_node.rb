class HippyNode
  
  attr_accessor :character, :parent
  
  def initialize(options={})
    @character = options[:character]
    @parent = options[:parent]
    @children = []
  end
  
  def root?
    @parent.nil?
  end
  
  def word?
    @isWord
  end
  
  def addString(string, start)
    if start == string.length
      unless @isWord
        HippyTree.step_word_count
        @isWord = true
      end
      return
    end
    
    char = string[start, 1]
    index = char.to_i
    @children[index] ||= HippyNode.new(:character => char, :parent => self)
    @children[index].addString(string, start + 1)
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
  
  def include?(string, start)
    if start == string.length
      return !!word?
    end
    
    index = string[start, 1].to_i
    child = @children[index]
    # puts "#{index} :: start: #{start} :: char: #{index} :: string: #{string.inspect}" if index > 1
    if child
      return child.include?(string, start + 1)
    end
    false
  end
  
end