require "colorize"
class Tile
	attr_reader :value

	def initialize(value)
		@value = value
		@given = !(value == 0)
		@color = given? ? :red : :blue
	end

	def given?
		@given
	end

	def value=(new_value)
		if given?
			puts "You can't change a given value."
		else
			@value = new_value
		end
	end

	def to_s
		value == 0 ? " " : @value.to_s.colorize(@color)
	end
end