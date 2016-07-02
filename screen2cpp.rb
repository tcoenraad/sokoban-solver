#!/usr/bin/env ruby
require_relative 'board'

if ARGV.empty?
  puts 'usage: screen2cpp.rb SCREEN_FILE'
  exit
end

File.open(ARGV.first, 'r') do |f|
  puts Board.parse(f.read).to_cpp
end
