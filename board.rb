require 'erb'
require_relative 'erb_helpers'

class Field
  WALL = 0
  MAN = 1
  GOAL = 2
  EMPTY = 3
  BLOCK = 4

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
  def initialize(board)
    @board = Board.parse(board)
  end

  def self.parse(board)
    board.each_line.map do |line|
      Line.parse(line.strip)
    end
  end

  def to_s
    @board.map do |line|
      line.map { |c| Field::FIELD_TO_CHAR[c] }.join
    end.join("\n")
  end

  def to_smv
    ERB.new(File.read('board.smv.erb')).result(binding)
  end
end
