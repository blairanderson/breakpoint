require 'spec_helper'

describe SimpleTextAreaParser do
  it 'parses lines and spaces' do
    multiple_lines = SimpleTextAreaParser.new("\"test@example.com\",    \ntest2@example.com\n\ntest3@example.com,\n")
    multiple_lines.extract_lines_and_spaces.should eq "\"test@example.com\", test2@example.com test3@example.com,"
  end

  it 'parses comma separated list with space' do
    with_space = SimpleTextAreaParser.new("test@example.com,test2@example.com,test3@example.com")
    with_space.parse.should eq ["test@example.com", "test2@example.com", "test3@example.com"]
  end

  it 'parses comma separated list with no space' do
    no_space = SimpleTextAreaParser.new("test@example.com,test2@example.com,test3@example.com")
    no_space.parse.should eq ["test@example.com", "test2@example.com", "test3@example.com"]
  end

  it 'parses comma separated list with space or no space' do
    mixed_spacing = SimpleTextAreaParser.new("test@example.com, test2@example.com,test3@example.com")
    mixed_spacing.parse.should eq ["test@example.com", "test2@example.com", "test3@example.com"]
  end

  it 'parses comma separated list with space or no space or no comma' do
    mixed_spacing = SimpleTextAreaParser.new("test@example.com, test2@example.com,test3@example.com test4@example.com")
    mixed_spacing.parse.should eq ["test@example.com", "test2@example.com", "test3@example.com", "test4@example.com"]
  end

  it 'parses list with bad punctuation' do
    mixed_spacing = SimpleTextAreaParser.new("(test@example.com; test2@example.com:test3@example.com \"test4@example.com\")")
    mixed_spacing.parse.should eq ["test@example.com", "test2@example.com", "test3@example.com", "test4@example.com"]
  end

  it 'only returns unique inputs' do
    duplicates = SimpleTextAreaParser.new("test@example.com, test@example.com, test@example.com")
    duplicates.parse.should eq ["test@example.com"]
  end
end

