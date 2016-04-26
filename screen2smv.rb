require_relative 'board'

File.open('screen.2000', 'r') do |f|
  puts Board.new(f.read).to_smv
end
