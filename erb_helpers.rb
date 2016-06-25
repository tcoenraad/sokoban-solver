require 'erb'

class ERBHelpers
  def self.to_comment(string)
    string.each_line.map do |line|
      '-- ' + line
    end.join
  end
end
