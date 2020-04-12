require_relative 'board.rb'

class Game
	def initialize(file_name)
		@board = Board.new(file_name)
	end

	def prompt_for_position
		puts "Please enter a valid position (e.g. 2,3)"
		position = gets.chomp.split(/\D/).map(&:to_i)
		while position.length != 2
			puts "Invalid position..."
			puts "Please enter a valid position (e.g. 2,3)"
			position = gets.chomp.split(/\D/).map(&:to_i)
		end
		position
	end

	def prompt_for_value
		puts "Please enter a valid value (only numbers from 0-9)"
		value = gets.chomp
		while !("0".."9").include?(value) || value.match("/\D/")
			puts "Invalid value..."
			puts "Please enter a valid value (only numbers from 0-9)"
			value = gets.chomp
		end
		value.to_i
	end

	def play
		while !board.solved?
			board.render
			position = self.prompt_for_position
			puts "Position: #{position.join(' ')}"
			value = self.prompt_for_value
			board.update_tile(position, value)
			system("cls")
		end
		board.render
		puts "The sudoku puzzle has been solved!"
	end

	private
	attr_reader :board
end