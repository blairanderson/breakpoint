# This class feels a bit overkill.
# But, it allowed me to test it easier.
class SimpleTextAreaParser
  attr_reader :input

  def self.parse(input)
    new(input).parse
  end

  def initialize(input)
    @input = input
  end

  def parse
    replace_punctuation
    extract_lines_and_spaces
    to_a
    input.uniq
  end

  def replace_punctuation
    @input = input.gsub(/[,";:()]/, " ")
  end

  def extract_lines_and_spaces
    @input = input.squish
  end

  def to_a
    @input = input.split(" ")
  end
end

