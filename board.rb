require 'erb'
require_relative 'erb_helpers'

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

  def initialize(board_string)
    @board = Board.parse(board_string).transpose
  end

  def self.parse(board_string)
    board = board_string.each_line.map do |line|
      Line.parse(line.strip)
    end

    longest_line_length = board.map(&:length).max
    board.each do |line|
      line[line.size..longest_line_length] = Field::WALL if line.size < longest_line_length
    end
  end

  def max_x
    @max_x ||= @board.size - 1
  end

  def max_y
    @max_y ||= @board.first.size - 1
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
    @board.transpose.map do |row|
      row.map { |field| Field::FIELD_TO_CHAR[field] }.join
    end.join("\n")
  end

  def to_smv
    ERB.new(File.read('board.smv.erb')).result(binding)
  end

  private

  def find_field(field_type)
    result = []
    @board.each_with_index.map do |col, y|
      col.each_with_index.map do |field, x|
        result << { x: y, y: x } if field == field_type
      end
    end
    result
  end
end
