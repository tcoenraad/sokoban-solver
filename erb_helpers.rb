require 'erb'

class ERBHelpers
  def self.as_comment(string)
    string.each_line.map do |line|
      '-- ' + line
    end.join
  end
end
