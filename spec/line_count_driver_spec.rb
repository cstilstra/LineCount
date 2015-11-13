require 'rspec'
require_relative '../line_count_driver'

describe LineCountDriver do

  let(:driver) {LineCountDriver.new}

  # Tests for initialize()
  it "initialize() creates the proper objects (FileReader)" do
    reader = driver.reader
    expect(reader).to be_truthy
  end

  # Tests for run_one_file()
  it "run_one_file(file_name) returns the correct counts of comment and code lines" do
    # Ruby
    test_file = File.open("test.rb", "w")
    test_file.puts("# Four comments")
    test_file.puts("# One line of code")
    test_file.puts("one_line_of_code = 1")
    test_file.puts("=begin")
    test_file.puts("=end")
    test_file.close
    result = driver.run_one_file("test.rb")
    expect(result).to eq([4,1])
    # Invalid file
    result = driver.run_one_file("test")
    expect(result).to eq([0,0])
  end

  # Tests for run_directory_recursively()
  it "run_directory_recursively(directory_name) returns the correct counts of comment and code lines" do
    driver.comment_count = 0
    driver.code_count = 0
    response = driver.run_directory_recursively("languages")
    expect(response).to eq([0, 38])
  end

  # Tests for add_response_to_counts()
  it "add_response_to_counts(response) correctly increments both counters" do
    driver.comment_count = 0
    driver.code_count = 0
    driver.add_response_to_counts([4,1])
    expect(driver.comment_count).to eq(4)
    expect(driver.code_count).to eq(1)
    driver.add_response_to_counts([2,17])
    expect(driver.comment_count).to eq(6)
    expect(driver.code_count).to eq(18)
  end

  # Tests for handle_command_line_arguments()
  it "handle_command_line_arguments() returns the correct values for the given arguments" do
    driver.comment_count = 0
    driver.code_count = 0
    arguments = ["languages"]
    response = driver.handle_command_line_arguments(arguments)
    expect(response).to eq(["0 comment lines", "38 code lines"])
  end


end
