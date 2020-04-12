require_relative 'board.rb'

class Solver
	def initialize(file_name)
		@board = Board.new(file_name)
		@current_cell = [0, 0]
	end

	def next_cell
		current_cell[1] += 1
		if current_cell[1] == 9
			current_cell[1] = 0 
			current_cell[0] += 1
		end
	end

	def backtrack
		current_cell[1] -= 1

		if current_cell[1] == -1
			current_cell[0] -= 1
			current_cell[1] = 8
		end
		
		if board[*current_cell].given?
			self.backtrack
		end
	end

	def place_values
		tile = get_valid_tile(current_cell)

		value_to_be_placed = find_correct_value(current_cell, tile.previous_guess + 1)

		value_to_be_placed == 10 ? go_back(tile) : place_value(tile, value_to_be_placed)

		system("cls")
		board.render
	end

	def solve
		while !board.solved?
			self.place_values
		end
	end

	private
	attr_reader :board
	attr_accessor :current_cell

	def get_valid_tile(current_cell)
		tile = board[*current_cell]
		while tile.given?
			self.next_cell
			tile = board[*current_cell]
		end
		tile
	end

	def go_back(tile)
		tile.value = 0
		tile.previous_guess = 0
		self.backtrack
	end

	def place_value(tile, value_to_be_placed)
		tile.value = value_to_be_placed
		tile.previous_guess = value_to_be_placed
		self.next_cell
	end

	def check_value(array, value_to_be_placed)
		if array.any? { |ele| ele == value_to_be_placed}
			return false
		else
			return true
		end
	end

	def row_correct?(row_number, value_to_be_placed)
		row = board.grid[row_number].map(&:value)
		check_value(row, value_to_be_placed)
	end

	def column_correct?(column_number, value_to_be_placed)
		column = board.grid.transpose[column_number].map(&:value)
		check_value(column, value_to_be_placed)
	end

	def find_current_square_number(current_cell)
		case current_cell[1]
		when (0..2)
			square_number = 1
		when (3..5)
			square_number = 2
		when (6..8)
			square_number = 3
		end

		case current_cell[0]
		when (3..5)
			square_number += 3
		when (6..8)
			square_number += 6
		end
		square_number
	end

	def square_correct?(value_to_be_placed)
		square_number = find_current_square_number(current_cell)
		square = board.get_square(square_number)
		all_values_in_square = square.flatten
		check_value(all_values_in_square, value_to_be_placed)
	end

	def find_correct_value(current_cell, value_to_be_placed)
		while !row_correct?(current_cell[0], value_to_be_placed) || 
			!column_correct?(current_cell[1], value_to_be_placed) ||
			!square_correct?(value_to_be_placed)
			value_to_be_placed += 1
			
			break if value_to_be_placed == 10
		end
		value_to_be_placed
	end
end