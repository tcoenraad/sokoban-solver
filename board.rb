require 'erb'

require_relative 'erb_helpers'

class Location
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    other.instance_of?(self.class) && x == other.x && y == other.y
  end
end

class Field
  WALL = 'WALL'.freeze
  MAN = 'MAN'.freeze
  GOAL = 'GOAL'.freeze
  EMPTY = 'EMPTY'.freeze
  BLOCK = 'BLOCK'.freeze

  CHAR_TO_FIELD = {
    '#' => Field::WALL,
    '@' => Field::MAN,
    '.' => Field::GOAL,
    ' ' => Field::EMPTY,
    '$' => Field::BLOCK
  }.freeze

  FIELD_TO_CHAR = CHAR_TO_FIELD.invert.freeze
end

class Line
  def self.parse(line)
    line.each_char.map do |char|
      Field::CHAR_TO_FIELD[char]
    end
  end
end

class Board
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def self.parse(board_string)
    board = board_string.each_line.map { |line| Line.parse(line.strip) }
    Board.new(board).normalize!.minimize!.transpose!
  end

  def normalize!
    longest_line_length = board.map(&:length).max
    board.each do |line|
      line.concat([Field::WALL] * (longest_line_length - line.size))
    end
    self
  end

  def minimize!
    remove_walls_horizontally(board)
    transpose!
    remove_walls_horizontally(board)
    transpose!
  end

  def transpose!
    @board = board.transpose
    self
  end

  def max_x
    @max_x ||= @board.size - 1
  end

  def max_y
    @max_y ||= @board.first.size - 1
  end

  def goals
    @goals ||= find_locations(Field::GOAL)
  end

  def blocks
    @blocks ||= find_locations(Field::BLOCK)
  end

  def transitionable_fields(iterations, delta_x, delta_y)
    fields.select { |f| (1..iterations).all? { |i| fields.include?(Location.new(f.x + i * delta_x, f.y + i * delta_y)) } }
  end

  def fields
    @fields ||= find_locations([Field::MAN, Field::GOAL, Field::EMPTY, Field::BLOCK])
  end

  def man
    @man ||= find_locations(Field::MAN).first
  end

  def to_s
    board.transpose.map do |row|
      row.map { |field| Field::FIELD_TO_CHAR[field] }.join
    end.join("\n")
  end

  def to_smv
    ERB.new(File.read('board.smv.erb')).result(binding)
  end

  def to_cpp
    ERB.new(File.read('board.cpp.erb'), 0, '-').result(binding)
  end

  private

  def find_locations(field_types)
    field_types = [field_types] unless field_types.is_a?(Array)

    result = []
    @board.each_with_index do |col, y|
      col.each_with_index do |field, x|
        result << Location.new(x, y) if field_types.include?(field)
      end
    end
    result
  end

  def remove_walls_horizontally(board)
    board.reject! { |line| line.all? { |field| field == Field::WALL } }
  end
end
