require File.dirname(__FILE__) + "/board_loader"
require File.dirname(__FILE__) + "/hexiom_solver"
require File.dirname(__FILE__) + "/bencher"

LEVEL = $*[$*.index("-n")+1].to_i rescue 2
USE_TREE = ($*[$*.index("-t")+1] == 'true' ? true : false) rescue false

puts " Level #{LEVEL}, " + (USE_TREE ? "Using Tree" : "Using Hash")

NO_SPACE = 9
BLANK_SPACE = 8

board = BoardLoader.load(LEVEL) #11)
# board.print
# puts ""

valid_pieces = board.flatten.reject{|x| (x == NO_SPACE || x < 0 || x == BLANK_SPACE) }.sort.reverse
# puts "valid pieces: #{valid_pieces.inspect}"

start_time = Time.now
solver = HexiomSolver.new(:tree => USE_TREE)
answer = solver.find_solution(BoardLoader.empty_board, valid_pieces)
if answer
  puts " Solution found"
  # answer.print
else
  puts " No solution found"
end

puts " Took: #{(Time.now - start_time)}, recorded #{solver.tried_count} tries"
# puts "Bencher Results:"
puts Bencher.inspect
