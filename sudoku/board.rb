require_relative "tile.rb"

class Board
	def self.from_file(file_name)
		grid = Array.new(9) { [] }
		file = file_data = File.read("./puzzles/" + file_name + ".txt").split
		file.each_with_index do |subarr, idx|
			subarr.each_char { |char| grid[idx] << Tile.new(char.to_i) }
		end
		grid
	end

	def initialize(file_name)
		@grid = Board::from_file(file_name)
	end

	def update_tile(position, new_value)
		unless (0..9).include?(new_value)
			puts "Illegal value."
		else
			self[*position].value = new_value
		end
	end

	def [](*position)
		row, col = position
		grid[row][col]
	end

	def render
		puts "  #{(0..8).to_a.join(' ')}"

		grid.each_with_index do |subarr, idx|
			puts "#{idx} #{subarr.join(" ")}"
		end
	end

	def solved?
		solved_all_rows? && solved_all_columns? && solved_all_squares?
	end

	private
	attr_reader :grid

	def get_starting_row(column_number)
		case column_number
		when (1..3)
			starting_row = 0
		when (4..6)
			starting_row = 3
		when (7..9)
			starting_row = 6
		end
	end

	def get_starting_column(column_number)
		case column_number % 3
		when 1
			starting_column = 0
		when 2
			starting_column = 3
		when 0
			starting_column = 6
		end
	end

	def solved_all_rows?
		grid.each do |row|
			row = row.map(&:value)
			return false if row != row.uniq || row.any? { |ele| ele == 0}
		end
		return true
	end

	def solved_all_columns?
		grid.each do |column|
			column = column.map(&:value)
			return false if column != column.uniq || column.any? { |ele| ele == 0}
		end
		return true
	end

	def get_transposed_grid
		return grid.transpose
	end

	def solved_all_squares?
		(1..9).each do |num|
			square = get_square(num)
			flat_square = square.flatten
			return false if flat_square != flat_square.uniq || flat_square.any? { |ele| ele == 0}
		end
		return true
	end

	def get_square(square_number)
		starting_row = get_starting_row(square_number)
		starting_column = get_starting_column(square_number)
		square = Array.new(3) { Array.new }
		square.each do |subarr|
			(starting_column..starting_column+2).each do |col|
				subarr << self[starting_row, col].value
			end
			starting_row += 1
		end
		square
	end
end