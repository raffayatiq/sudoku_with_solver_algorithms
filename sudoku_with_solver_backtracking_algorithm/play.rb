require_relative 'solver.rb'
def play
	puts "Choose a puzzle..."
	puts "1. sudoku1"
	puts "2. sudoku2"
	puts "3. sudoku3"
	puzzle = gets.chomp
	while !('1'..'3').include?(puzzle)
		puts "Enter valid input."
		puts "Choose a puzzle..."
		puts "1. sudoku1"
		puts "2. sudoku2"
		puts "3. sudoku3"
		puzzle = gets.chomp.to_i
	end
	system('cls')
	solver = Solver.new('sudoku' + puzzle)
	solver.solve
end

play