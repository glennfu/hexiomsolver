require File.dirname(__FILE__) + "/board_loader"
require File.dirname(__FILE__) + "/hexiom_solver"
require File.dirname(__FILE__) + "/bencher"

LEVEL = $*[$*.index("-l")+1].to_i rescue 2
USE_TREE = ($*[$*.index("-t")+1] == 'true' ? true : false) rescue false
VERBOSE = ($*[$*.index("-v")+1] == 'true' ? true : false) rescue false
PRINT_WORDS = !$*.index("-w").nil?
SCORING_MODE = !$*.index("-score").nil?

NO_SPACE = 9
BLANK_SPACE = 8

if SCORING_MODE
  puts "Scoring time for many levels #{USE_TREE ? "using Tree" : "using Hash"}:"

  start_time = Time.now

  trap "TSTP" do
    puts "Current state:"
    puts " Took: #{(Time.now - start_time)}"
    puts Bencher.inspect
  end

  trap "INT" do
    puts "\nInterrupted, here's how what I got so far:"
    puts " Took: #{(Time.now - start_time)}"
    puts Bencher.inspect
    exit
  end

  [2, 3, 4, 6, 11].each do |level|
    print "."; $stdout.flush
    board = BoardLoader.load(level)
    print "."; $stdout.flush
    valid_pieces = board.flatten.reject{|x| (x == NO_SPACE || x < 0 || x == BLANK_SPACE) }.sort.reverse
    print "."; $stdout.flush
    solver = HexiomSolver.new(:tree => USE_TREE)
    print "."; $stdout.flush
    answer = solver.find_solution(BoardLoader.empty_board, valid_pieces)
    print level; $stdout.flush
  end
  puts "\n Took: #{(Time.now - start_time)}"
  puts Bencher.inspect

else
  solver = HexiomSolver.new(:tree => USE_TREE)
  
  trap "TSTP" do
    puts "Current state:"
    puts " Took: #{(Time.now - start_time)}, recorded #{solver.tried_count} tries"
    puts Bencher.inspect
    puts solver.print_words if PRINT_WORDS
  end

  trap "INT" do
    puts "\nInterrupted, here's how what I got so far:"
    puts " Took: #{(Time.now - start_time)}, recorded #{solver.tried_count} tries"
    puts Bencher.inspect
    puts solver.print_words if PRINT_WORDS
    exit
  end
  
  puts " Level #{LEVEL}, " + (USE_TREE ? "Using Tree" : "Using Hash")

  board = BoardLoader.load(LEVEL) #11)
  if VERBOSE
    board.print
    puts ""
  end

  valid_pieces = board.flatten.reject{|x| (x == NO_SPACE || x < 0 || x == BLANK_SPACE) }.sort.reverse
  # puts "valid pieces: #{valid_pieces.inspect}"

  start_time = Time.now
  answer = solver.find_solution(BoardLoader.empty_board, valid_pieces)
  if answer
    puts " Solution found"
    answer.print if VERBOSE
  else
    puts " No solution found"
  end

  puts " Took: #{(Time.now - start_time)}, recorded #{solver.tried_count} tries"
  # puts "Bencher Results:"
  puts Bencher.inspect
  puts solver.print_words if PRINT_WORDS
  
end
