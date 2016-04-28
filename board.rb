require 'erb'
require_relative 'erb_helpers'

class Field
  WALL = "WALL"
  MAN = "MAN"
  GOAL = "GOAL"
  EMPTY = "EMPTY"
  BLOCK = "BLOCK"

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
    @board = Board.parse(board)
  end

  def self.parse(board)
    board.each_line.map do |line|
      Line.parse(line.strip)
    end
  end

  def max_x
    @max_x ||= @board.count
  end

  def max_y
    @max_y ||= @board.first.count
  end

  def goals
    @goals ||= find_field(Field::GOAL)
  end

  def blocks
    @blocks ||= find_field(Field::BLOCK)
  end

  def man
    @man ||= find_field(Field::MAN).first
  end

  def to_s
    @board.map do |row|
      row.map { |field| Field::FIELD_TO_CHAR[field] }.join
    end.join("\n")
  end

  def to_smv
    ERB.new(File.read('board.smv.erb')).result(binding)
  end

  private

  def find_field(field_type)
    result = []
    @board.each_with_index.map do |row, y|
      row.each_with_index.map do |field, x|
        result << { x: x, y: y } if field == field_type
      end
    end
    result
  end
end
