require File.dirname(__FILE__) + "/board_loader"
require File.dirname(__FILE__) + "/hexiom_solver"
require File.dirname(__FILE__) + "/hippy_tree"
require File.dirname(__FILE__) + "/bencher"

NO_SPACE = 9
BLANK_SPACE = 8
USE_TREE = true

board = BoardLoader.load(5)
board.print
puts ""


valid_pieces = board.flatten.reject{|x| (x == NO_SPACE || x < 0 || x == BLANK_SPACE) }.sort.reverse
# puts "valid pieces: #{valid_pieces.inspect}"

start_time = Time.now
solver = HexiomSolver.new
answer = solver.find_solution(BoardLoader.empty_board, valid_pieces)
if answer
  answer.print
else
  puts "No solution found"
end

puts "Took: #{(Time.now - start_time)}, recorded #{USE_TREE ? HippyTree.word_count : $tried_solutions.length} tries"
puts "Bencher: #{Bencher.inspect}"
