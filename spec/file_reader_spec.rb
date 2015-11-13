require 'rspec'
require_relative 'spec_helper'
require_relative '../file_reader'

describe FileReader do

  let(:reader) {FileReader.new}

  it "get_file_extension(file_name) returns the correct extension from file_name" do
    response = reader.get_file_extension("test.txt")
    expect(response).to eq(".txt")
  end

  it "load_language_extensions() returns hash map of all associated extensions and languages found in 'languages' folder" do
    response = reader.load_language_extensions()
    #expect(response).to eq({".java"=>"java", ".class"=>"java", ".rb"=>"ruby", ".cpp"=>"c++"})
    arr = reader.extension_language_pairs
    expect(arr.length).to eq(6)
  end

  it "determine_language(extension) returns the correct language" do
    response = reader.determine_language(".rb")
    expect(response).to eq(1)
    response = reader.determine_language(".class")
    expect(response).to eq(0)
    response = reader.determine_language(".java")
    expect(response).to eq(0)
    response = reader.determine_language(".cpp")
    expect(response).to eq(3)
    response = reader.determine_language(".json")
    expect(response).to eq(2)
    response = reader.determine_language(".trick")
    expect(response).to eq("unknown")
  end

  it "get_language_for_file(file_name) returns the correct language definition object" do
    response = reader.get_language_for_file("test.rb")
    expect(response.language_name).to eq("ruby")
    response = reader.get_language_for_file("test.java")
    expect(response.language_name).to eq("java")
    response = reader.get_language_for_file("test.class")
    expect(response.language_name).to eq("java")
    response = reader.get_language_for_file("test.cpp")
    expect(response.language_name).to eq("c++")
  end

  it "zero_counts() correctly zeroes the comment and code counts" do
    reader.zero_counts
    expect(reader.comment_count).to eq(0)
    expect(reader.code_count).to eq(0)
  end

  it "scan_file_with_language(file_name,language_definition_object) returns the correct counts of comment and code lines" do
    # ruby
    test_file = File.open("test.rb", "w")
    test_file.puts("# Four comments")
    test_file.puts("# One line of code")
    test_file.puts("one_line_of_code = 1")
    test_file.puts("=begin")
    test_file.puts("=end")
    test_file.close
    result = reader.scan_file_with_language("test.rb", reader.language_definition_objects[1])
    expect(result).to eq([4,1])
    # java
    test_file = File.open("test.class", "w")
    test_file.puts("// Five comments")
    test_file.puts("// One line of code")
    test_file.puts("one_line_of_code = 1")
    test_file.puts("/*")
    test_file.puts("this line is just straight up comment")
    test_file.puts("*/")
    test_file.close
    result = reader.scan_file_with_language("test.class", reader.language_definition_objects[0])
    expect(result).to eq([5,1])
    test_file = File.open("test.java", "w")
    test_file.puts("// Five comments")
    test_file.puts("// One line of code")
    test_file.puts("one_line_of_code = 1")
    test_file.puts("/*")
    test_file.puts('')
    test_file.puts("this line is just straight up comment")
    test_file.puts("*/")
    test_file.close
    result = reader.scan_file_with_language("test.java", reader.language_definition_objects[0])
    expect(result).to eq([5,1])
    # c++
    test_file = File.open("test.cpp", "w")
    test_file.puts("// Five comments")
    test_file.puts("// One line of code")
    test_file.puts("one_line_of_code = 1")
    test_file.puts('')
    test_file.puts("/*")
    test_file.puts("this line is just straight up comment")
    test_file.puts("*/")
    test_file.close
    result = reader.scan_file_with_language("test.cpp", reader.language_definition_objects[0])
    expect(result).to eq([5,1])
  end

  it "read_file(file_name) returns the correct counts of comment and code lines" do
    # ruby
    test_file = File.open("test.rb", "w")
    test_file.puts("# Four comments")
    test_file.puts("# One line of code")
    test_file.puts("one_line_of_code = 1")
    test_file.puts("=begin")
    test_file.puts("=end")
    test_file.close
    result = reader.read_file("test.rb")
    expect(result).to eq([4,1])
  end

end
